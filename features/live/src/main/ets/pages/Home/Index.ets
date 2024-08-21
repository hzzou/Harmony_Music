import { Header } from './components/Header';
import { LiveList } from './components/LiveList';

@Entry
@Component
struct Index {
  @State message: string = 'Music Live';

  build() {
    Column() {
      Header()
      LiveList()
    }
    .width('100%')
    .height('100%')
  }
}