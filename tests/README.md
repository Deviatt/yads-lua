## LuaJIT
#### JIT: ON SSE3 SSE4.1 BMI2 fold cse dce fwd dse narrow loop abc sink fuse
| Serializer                                        | sum      | avg      | med      | size
| ------------------------------------------------- | -------- | -------- | -------- | --
| yads serial                                       | 0.783000 | 0.078300 | 0.078000 | 68
| yads de/serial                                    | 1.398000 | 0.139800 | 0.139000 | --
| [von](https://github.com/vercas/vON) serial       | 2.738000 | 0.273800 | 0.274000 | 90
| [von](https://github.com/vercas/vON) de/serial    | 6.545000 | 0.654500 | 0.655000 | --
| [json](https://github.com/rxi/json.lua) serial    | 2.703000 | 0.270300 | 0.271000 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 7.107000 | 0.710700 | 0.713500 | --
| pon serial                                        | 2.027000 | 0.202700 | 0.202000 | 92
| pon de/serial                                     | 4.320000 | 0.432000 | 0.435000 | --

#### JIT: ON SSE3 SSE4.1 BMI2
| Serializer                                        | sum      | avg      | med      | size
| ------------------------------------------------- | -------- | -------- | -------- | --
| yads serial                                       | 1.107000 | 0.110700 | 0.110500 | 68
| yads de/serial                                    | 1.883000 | 0.188300 | 0.188500 | --
| [von](https://github.com/vercas/vON) serial       | 2.796000 | 0.279600 | 0.280500 | 90
| [von](https://github.com/vercas/vON) de/serial    | 6.773000 | 0.677300 | 0.679000 | --
| [json](https://github.com/rxi/json.lua) serial    | 2.509000 | 0.250900 | 0.252500 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 8.366000 | 0.836600 | 0.838500 | --
| pon serial                                        | 2.030000 | 0.203000 | 0.203500 | 92
| pon de/serial                                     | 4.313000 | 0.431300 | 0.429500 | --

#### JIT: OFF SSE3 SSE4.1 BMI2
| Serializer                                        | sum       | avg      | med      | size
| ------------------------------------------------- | --------- | -------- | -------- | --
| yads serial                                       | 2.163000  | 0.216300 | 0.218000 | 68
| yads de/serial                                    | 4.279000  | 0.353900 | 0.355500 | --
| [von](https://github.com/vercas/vON) serial       | 3.539000  | 0.279600 | 0.280500 | 90
| [von](https://github.com/vercas/vON) de/serial    | 9.367000  | 0.936700 | 0.944500 | --
| [json](https://github.com/rxi/json.lua) serial    | 3.939000  | 0.393900 | 0.387000 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 12.852000 | 1.285200 | 1.273500 | --
| pon serial                                        | 3.207000  | 0.320700 | 0.321000 | 92
| pon de/serial                                     | 6.497000  | 0.649700 | 0.646500 | --

## Lua 5.4
| Serializer                                        | sum       | avg      | med      | size
| ------------------------------------------------- | --------- | -------- | -------- | --
| yads serial                                       | 4.350000  | 0.435000 | 0.438500 | 68
| yads de/serial                                    | 8.978000  | 0.897800 | 0.905500 | --
| [von](https://github.com/vercas/vON) serial       | 9.385000  | 0.938500 | 0.942500 | 90
| [von](https://github.com/vercas/vON) de/serial    | 21.409000 | 2.140900 | 2.148000 | --
| [json](https://github.com/rxi/json.lua) serial    | 11.091000 | 1.109100 | 1.117500 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 27.936000 | 2.793600 | 2.790000 | --
| pon serial                                        | 6.728000  | 0.672800 | 0.667500 | 92
| pon de/serial                                     | 14.006000 | 1.400600 | 1.389500 | --
