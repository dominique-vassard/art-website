module Main exposing (..)

import Html exposing (Html, button, div, text, img, i, span)
import Html.Attributes exposing (style, class, src, width)
import Html.Events exposing (onClick)
import Http exposing (get, send)
import Json.Decode exposing (string, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Random exposing (list, int)
import Helpers.ZipList as ZipList
    exposing
        ( ZipList
        , init
        , forward
        , current
        , hasPrevious
        , hasNext
        , next
        )


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Flags =
    { api_url : String
    , seed : Int
    }


type Direction
    = Previous
    | Next


type WorkType
    = Drawings
    | Paintings


type alias ImageList =
    { result : String
    , links : List String
    }


type alias Model =
    { api_url : String
    , modal_opened : Bool
    , images : ZipList String
    , work_type : WorkType
    , currentSeed : Int
    }



-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        initial_work_type =
            Paintings
    in
        ( { api_url = flags.api_url
          , modal_opened = False
          , images =
                ZipList.init "" []
          , work_type = initial_work_type
          , currentSeed = flags.seed
          }
        , getImageList flags.api_url initial_work_type
        )



-- UPDATE


type Msg
    = MoveTo Direction
    | OpenModal
    | CloseModal
    | NewImageList (Result Http.Error ImageList)
    | ViewWorkType WorkType


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MoveTo Next ->
            ( { model | images = ZipList.forward model.images }, Cmd.none )

        MoveTo Previous ->
            ( { model | images = ZipList.back model.images }, Cmd.none )

        OpenModal ->
            ( { model | modal_opened = True }, Cmd.none )

        CloseModal ->
            ( { model | modal_opened = False }, Cmd.none )

        ViewWorkType work_type ->
            ( { model | work_type = work_type }
            , getImageList model.api_url work_type
            )

        NewImageList (Ok { result, links }) ->
            let
                hd =
                    Maybe.withDefault "" (List.head links)

                tl =
                    Maybe.withDefault [] (List.tail links)

                imageList =
                    if List.length links > 0 && result == "success" then
                        --ZipList.init hd tl
                        shuffleImageList model.currentSeed links
                            |> toZipList
                    else
                        model.images
            in
                ( { model | images = imageList }, Cmd.none )

        NewImageList (Err msg) ->
            ( model, Cmd.none )



-- HELPERS


shuffleImageList : Int -> List String -> List String
shuffleImageList seed imageList =
    imageList
        |> List.map2 (,) (getRandomIntList (List.length imageList + 1) seed)
        |> List.sortBy Tuple.first
        |> List.unzip
        |> Tuple.second


getRandomIntList : Int -> Int -> List Int
getRandomIntList len seed =
    Random.initialSeed seed
        |> Random.step (Random.list len (Random.int 0 1000))
        |> Tuple.first


toZipList : List String -> ZipList String
toZipList items =
    let
        hd =
            Maybe.withDefault "" (List.head items)

        tl =
            Maybe.withDefault [] (List.tail items)
    in
        ZipList [] hd tl



-- COMMANDS


getImageList : String -> WorkType -> Cmd Msg
getImageList api_url work_type =
    let
        url =
            api_url ++ "/api/works/get_list/" ++ (workTypeToText work_type "en")

        request =
            Http.get url imageListDecoder
    in
        Http.send NewImageList request


imageListDecoder : Decoder ImageList
imageListDecoder =
    decode ImageList
        |> required "result" string
        |> required "links" (Json.Decode.list string)


workTypeToText : WorkType -> String -> String
workTypeToText work_type language =
    case work_type of
        Drawings ->
            if language == "en" then
                "drawings"
            else
                "Dessins"

        Paintings ->
            if language == "en" then
                "paintings"
            else
                "Peintures"


getAllWorkTypes : List WorkType
getAllWorkTypes =
    [ Paintings, Drawings ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "gallery-container" ]
        [ viewModal model
        , div [ class "sm-col col-12 fit center" ]
            (List.map (viewWorkTypeButton model) getAllWorkTypes)
        , div [ class "sm-col col-12 fit gallery" ]
            [ viewControl model Previous
            , div
                [ class "sm-col col-10 flex flex-center gallery-height" ]
                [ img
                    [ class "img-slide"
                    , src (ZipList.current model.images)
                    , onClick OpenModal
                    ]
                    []
                , preloadNextImage model
                ]
            , viewControl model Next
            ]
        ]


preloadNextImage : Model -> Html Msg
preloadNextImage model =
    let
        preloadImg =
            case ZipList.next model.images of
                Maybe.Just nextItem ->
                    img [ class "display-none", src nextItem ] []

                Maybe.Nothing ->
                    div [] []
    in
        preloadImg


viewWorkTypeButton : Model -> WorkType -> Html Msg
viewWorkTypeButton model work_type =
    let
        selected_btn =
            if work_type == model.work_type then
                "selected"
            else
                ""
    in
        button
            [ class ("btn btn-primary mb1 work-type " ++ selected_btn)
            , onClick (ViewWorkType work_type)
            ]
            [ text (workTypeToText work_type "fr") ]


viewModal : Model -> Html Msg
viewModal model =
    let
        modal =
            if model.modal_opened then
                div [ class "gallery-modal" ]
                    [ div [ class "modal-content" ]
                        [ div []
                            [ span
                                [ class "modal-close"
                                , onClick CloseModal
                                ]
                                [ i [ class "fa fa-close" ] [] ]
                            ]
                        , div [ class "flex flex-center" ]
                            [ img
                                [ class "img-slide-modal"
                                , src (ZipList.current model.images)
                                , onClick CloseModal
                                ]
                                []
                            ]
                        ]
                    ]
            else
                div [] []
    in
        modal


viewControl : Model -> Direction -> Html Msg
viewControl model direction =
    let
        disabled_control =
            case direction of
                Previous ->
                    if ZipList.hasPrevious model.images then
                        ""
                    else
                        "disabled"

                Next ->
                    if ZipList.hasNext model.images then
                        ""
                    else
                        "disabled"

        direction_style =
            case direction of
                Previous ->
                    "left"

                Next ->
                    "right"
    in
        div
            [ class "sm-col col-1 flex flex-column gallery-control-container"
            ]
            [ i
                [ class
                    ("fa fa-chevron-"
                        ++ direction_style
                        ++ " fa-4x flex-auto center "
                        ++ "gallery-control "
                        ++ disabled_control
                    )
                , onClick (MoveTo direction)
                ]
                []
            ]
