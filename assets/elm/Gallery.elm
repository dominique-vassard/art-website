module Main exposing (..)

import Html exposing (Html, div, text, img, i, span)
import Html.Attributes exposing (style, class, src, width)
import Html.Events exposing (onClick)
import Helpers.ZipList as ZipList
    exposing
        ( ZipList
        , init
        , forward
        , current
        , hasPrevious
        )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Direction
    = Previous
    | Next


type alias Model =
    { modal_opened : Bool
    , images : ZipList String
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { modal_opened = False
      , images =
            ZipList.init
                "./images/artworks/dessins-1.png"
                [ "./images/artworks/peintures-7.jpg"
                , "./images/artworks/peintures-8.jpg"
                , "./images/artworks/peintures-9.jpg"
                , "./images/artworks/peintures-hor.jpg"
                , "./images/artworks/peintures-10.jpg"
                , "./images/artworks/peintures-11.jpg"
                , "./images/artworks/peintures-12.jpg"
                ]
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = MoveTo Direction
    | OpenModal
    | CloseModal


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewModal model
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
                ]
            , viewControl model Next
            ]
        ]


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
                                [ text "X" ]
                            ]
                        , div [ class " flex flex-center" ]
                            [ img
                                [ class "img-slide"
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
            [ class "sm-col col-1 flex flex-center gallery-height"
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
