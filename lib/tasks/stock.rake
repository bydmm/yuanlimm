namespace :stock do
  task :hold, [:nick_name, :stock] => [:environment] do |t, args|
    u = User.find_by(nick_name: args[:nick_name])
    s = Stock.find(args[:stock])
    u.pay_stock(s, { reason: '福利控股' }, 50_000, 'give').save
    puts u.nick_name, s.name, 50_000
  end

  task fix: :environment do
    love_powers = {}
    Transaction.where(pay_type: 'love').find_each do |transaction|
      love_power = transaction.detail[:love_power]
      if love_powers[love_power] && (transaction.created_at - love_powers[love_power] < 1.minutes)
        if transaction.type == 'StockTransaction'
          next if transaction.payee.stock_balance(transaction.stock) < transaction.amount
        else
          next if transaction.payee.balance < transaction.amount
        end
        transaction.class.create!(
          payer_id: transaction.payee_id,
          payee_id: 0,
          stock: transaction.stock,
          pay_type: 'give',
          amount: transaction.amount,
          detail: { reason: '您是付费测试的受害者' }
        )
      else
        love_powers[love_power] = transaction.created_at
      end
    end
  end

  task init: :environment do
    Stock.destroy_all
    Stock.create!(
      order: 0,
      code: 'KOTONOHA',
      name: '桂言叶',
      tags: ['日在校园', 'School Days', '黑化'],
      video_link: '//cdn.yuanlimm.com/kotonoha.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28748863&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'BLACKLOTUS',
      name: '黑雪姬',
      tags: ['加速世界', '学姐'],
      video_link: '//cdn.yuanlimm.com/blacklotus.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28391972&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'SHOUKO',
      name: '西宫硝子',
      tags: ['声之形', '聲の形'],
      video_link: '//cdn.yuanlimm.com/shouko.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=431610015&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'TOMOYO',
      name: '坂上智代',
      tags: ['CLANNAD', '武帝'],
      video_link: '//cdn.yuanlimm.com/tomoyo.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=22706982&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'KYOU',
      name: '藤林杏',
      tags: ['CLANNAD', '班长', '字典帝'],
      video_link: '//cdn.yuanlimm.com/kyou.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=22706992&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'YAYA',
      name: '夜夜',
      tags: ['机巧少女不会受伤', '人偶', '日日夜夜', '白丝'],
      video_link: '//cdn.yuanlimm.com/yaya.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28160602&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'RUIKO',
      name: '佐天泪子',
      tags: ['某科学的超电磁炮', 'LV6上升气流'],
      video_link: '//cdn.yuanlimm.com/ruiko.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28718995&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'IROHA',
      name: '一色彩羽',
      tags: ['我的青春恋爱物语果然有问题', '金发', '学妹'],
      video_link: '//cdn.yuanlimm.com/iroha.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=41554289&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'YUIGAHAMA',
      name: '由比滨结衣',
      tags: ['我的青春恋爱物语果然有问题', '团子'],
      video_link: '//cdn.yuanlimm.com/yuigahama.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=32432250&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'KAORI',
      name: '宫园薰',
      tags: ['四月是你的谎言', '金发'],
      video_link: '//cdn.yuanlimm.com/kaori.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=30798036&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'KOKOMI',
      name: '照桥心美',
      tags: ['齐木楠雄的灾难', '妹妹', '爱衣酱大胜利'],
      video_link: '//cdn.yuanlimm.com/kokomi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=441437290&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'MIRAI',
      name: '栗山未来',
      tags: ['境界的彼方', '眼镜', '学妹'],
      video_link: '//cdn.yuanlimm.com/mirai.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28029422&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'MAFUYU',
      name: '椎名真冬',
      tags: ['学生会的一己之见', '妹妹', '宅女', '金发'],
      video_link: '//cdn.yuanlimm.com/mafuyu.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=587552&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'SORA',
      name: '春日野穹',
      tags: ['缘之空', '穹妹', '妹妹'],
      video_link: '//cdn.yuanlimm.com/sora.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=527421783&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'QUETZALCOHUATL',
      name: '露科亚',
      tags: ['小林家的龙女仆', '如果你是龙,也好'],
      video_link: '//cdn.yuanlimm.com/quetzalcohuatl.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=465973080&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'RIKKA',
      name: '小鸟游六花',
      tags: ['中二病也要谈恋爱！', '中二病'],
      video_link: '//cdn.yuanlimm.com/rikka.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=27747191&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'MIO',
      name: '秋山澪',
      tags: ['轻音少女', 'KON', '蓝白碗'],
      video_link: '//cdn.yuanlimm.com/mio.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29829489&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'TOHKA',
      name: '夜刀神十香',
      tags: ['约会大作战'],
      video_link: '//cdn.yuanlimm.com/tohka.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26541649&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'YASUHARA',
      name: '安原绘麻',
      tags: ['白箱', '魔法少女'],
      video_link: '//cdn.yuanlimm.com/yasuhara.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=34852178&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'HOMURA',
      name: '晓美焰',
      tags: ['魔法少女小圆', '魔法少女'],
      video_link: '//cdn.yuanlimm.com/homura.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=496902080&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'ICARUS',
      name: '伊卡洛斯',
      tags: ['天降之物', '天使'],
      video_link: '//cdn.yuanlimm.com/icarus.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28481582&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'ALTAIR',
      name: '阿尔泰尔',
      tags: ['Re:CREATORS', '女王'],
      video_link: '//cdn.yuanlimm.com/altair.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=544000167&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'SMASHIRO',
      name: '椎名真白',
      tags: ['樱花庄的宠物女孩', '金发', '爱衣酱大胜利'],
      video_link: '//cdn.yuanlimm.com/smashiro.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28786038&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'CHITOGE',
      name: '桐崎千棘',
      tags: ['伪恋', '金发', '大小姐', '傲娇'],
      video_link: '//cdn.yuanlimm.com/chitoge.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28411334&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'KIRIKO',
      name: '桐子',
      tags: ['SAO', '刀剑神域', '桐谷和人', '伪娘'],
      video_link: '//cdn.yuanlimm.com/kiriko.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29027463&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'ASUNA',
      name: '结城明日奈',
      tags: ['SAO', '刀剑神域', '亚丝娜', '劳模', '大小姐', '金发'],
      video_link: '//cdn.yuanlimm.com/asuna.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29027453&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'ANGEL',
      name: '立华奏',
      tags: ['Angel Beats!', '学生会长', '天使'],
      video_link: '//cdn.yuanlimm.com/angel.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28699610&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'MIUNA',
      name: '潮留美海',
      tags: ['来自风平浪静的明天', '萝莉'],
      video_link: '//cdn.yuanlimm.com/miuna.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=31560996&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'SHANA',
      name: '夏娜',
      tags: ['灼眼的夏娜', '钉宫', '傲娇', '贫乳', '水手服'],
      video_link: '//cdn.yuanlimm.com/shana.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=592650&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'SHIKI',
      name: '两仪式',
      tags: ['空之境界', '月球'],
      video_link: '//cdn.yuanlimm.com/shiki.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26323020&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'BAYONETTA',
      name: '贝优妮塔',
      tags: ['猎天使魔女', '女王', '抖S', 'SXG'],
      video_link: '//cdn.yuanlimm.com/bayonetta.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=546505&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'HOZUMI',
      name: '无名',
      tags: ['甲铁城的卡巴内利', '無名'],
      video_link: '//cdn.yuanlimm.com/hozumi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=417953683&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'KURONEKO',
      name: '五更琉璃',
      tags: ['我的妹妹不可能那么可爱', '中二病'],
      video_link: '//cdn.yuanlimm.com/kuroneko.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=4921200&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'MAIKA',
      name: '樱之宫莓香',
      tags: ['调教咖啡厅', '抖S', '女仆'],
      video_link: '//cdn.yuanlimm.com/maika.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=519943318&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'YUUKO',
      name: '雨宫优子',
      tags: ['ef - a tale of memories.', '天使'],
      video_link: '//cdn.yuanlimm.com/ayuuko.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=4953582&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'EMT',
      name: '爱蜜莉雅',
      tags: ['从零开始的异世界生活', '魔女'],
      video_link: '//cdn.yuanlimm.com/emilia.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=426502173&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'KARASUMA',
      name: '乌丸千岁',
      tags: ['少女编号', '偶像'],
      video_link: '//cdn.yuanlimm.com/karasuma.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=479029305&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'KOTORI',
      name: '南小鸟',
      tags: ['LoveLive!', '偶像'],
      video_link: '//cdn.yuanlimm.com/kotori.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=550138074&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'NICONICONI',
      name: '矢泽妮可',
      tags: ['LoveLive!', '双马尾', '偶像'],
      video_link: '//cdn.yuanlimm.com/niconiconi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=565966116&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'FBB',
      name: '冯宝宝',
      tags: ['一人之下'],
      video_link: '//cdn.yuanlimm.com/fbb.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=518117599&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'REM',
      name: '蕾姆',
      tags: ['从零开始的异世界生活', '女仆'],
      video_link: '//cdn.yuanlimm.com/rem.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=474739193&auto=0&height=66'
    )
    Stock.create!(
      order: 60,
      code: 'SHIMA',
      name: '志摩凛',
      tags: ['摇曳露营'],
      video_link: '//cdn.yuanlimm.com/shima.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=531051181&auto=0&height=66'
    )
    stock = Stock.create!(
      order: 60,
      code: 'SHODAI',
      name: '木之本樱',
      tags: ['初代萌王', '魔卡少女樱', '魔法少女', '萝莉'],
      video_link: '//cdn.yuanlimm.com/shodai.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=534066224&auto=0&height=66'
    )
    Stock.create!(
      order: 60,
      code: 'MITSUHA',
      name: '宫水三叶',
      tags: ['你的名字'],
      video_link: '//cdn.yuanlimm.com/mitsuha.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=503619284&auto=0&height=66'
    )
    Stock.create!(
      order: 60,
      code: 'INORI',
      name: '楪祈',
      tags: ['罪恶王冠', 'EGOIST'],
      video_link: '//cdn.yuanlimm.com/inori.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=31649311&auto=0&height=66'
    )
    Stock.create!(
      order: 60,
      code: 'SENJOUGAHARA',
      name: '战场原黑仪',
      tags: ['荡漾', '物语系列'],
      video_link: '//cdn.yuanlimm.com/senjougahara.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=399367218&auto=0&height=66'
    )
    Stock.create!(
      order: 60,
      code: 'SHIRO',
      name: '白』',
      tags: ['NO GAME NO LIFE'],
      video_link: '//cdn.yuanlimm.com/shiro.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29713168&auto=0&height=66'
    )
    Stock.create!(
      order: 60,
      code: 'TAKANASHI',
      name: '小鸟游美羽',
      tags: ['要听爸爸的', '金发', '双马尾', '萝莉'],
      video_link: '//cdn.yuanlimm.com/takanashi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=31545432&auto=0&height=66'
    )
    Stock.create!(
      order: 60,
      code: 'HANABI',
      name: '安乐冈花火',
      tags: ['人渣的本愿'],
      video_link: '//cdn.yuanlimm.com/hanabi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=463842649&auto=0&height=66'
    )
    Stock.create!(
      order: -10,
      code: 'VIOLET',
      name: '薇尔莉特·伊芙加登',
      tags: ['紫罗兰永恒花园'],
      video_link: '//cdn.yuanlimm.com/violet.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=534065323&auto=0&height=66'
    )
    Stock.create!(
      order: -9,
      code: 'RUKINO',
      name: '流木野咲',
      tags: ['革命机valvrave'],
      video_link: '//cdn.yuanlimm.com/rukino.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26544365&auto=0&height=66'
    )
    Stock.create!(
      order: -6,
      code: 'HIFUMI',
      name: '泷本日富美',
      tags: ['NEW GAME!'],
      video_link: '//cdn.yuanlimm.com/hifumi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=534542204&auto=0&height=66'
    )
    Stock.create!(
      order: -8,
      code: 'NENE',
      name: '樱宁宁',
      tags: ['NEW GAME!', '金发'],
      video_link: '//cdn.yuanlimm.com/nene.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=421149002&auto=0&height=66'
    )
    Stock.create!(
      order: -7,
      code: 'AOBA',
      name: '凉风青叶',
      tags: ['NEW GAME!', '双马尾'],
      video_link: '//cdn.yuanlimm.com/aoba.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=493042314&auto=0&height=66'
    )
    Stock.create!(
      order: -5,
      code: 'ASUKA',
      name: '惣流·明日香·兰格雷',
      tags: ['EVA'],
      video_link: '//cdn.yuanlimm.com/asuka.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=503296&auto=0&height=66'
    )
    Stock.create!(
      order: -4,
      code: '214',
      name: '肥宅',
      tags: ['DARLING in the FRANXX'],
      video_link: '//cdn.yuanlimm.com/214.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=487541478&auto=0&height=66'
    )
    Stock.create!(
      order: -3,
      code: '02',
      name: '泽拉图',
      tags: ['DARLING in the FRANXX', '驯兽染', '天降'],
      video_link: '//cdn.yuanlimm.com/02.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=531051597&auto=0&height=66'
    )
    Stock.create!(
      order: -2,
      code: '016',
      name: '莓良心',
      tags: ['DARLING in the FRANXX', '驯兽染'],
      video_link: '//cdn.yuanlimm.com/016.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=547976226&auto=0&height=66'
    )
    Stock.create!(
      order: -1,
      code: 'OGISO',
      name: '小木曾雪菜',
      tags: ['白色相簿2', '白学'],
      video_link: '//cdn.yuanlimm.com/ogiso.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28390033&auto=0&height=66'
    )
    Stock.create!(
      order: -1,
      code: 'TOUMA',
      name: '冬马和纱',
      tags: ['白色相簿2', '白学'],
      video_link: '//cdn.yuanlimm.com/touma.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=449824918&auto=0&height=66'
    )
    Stock.create!(
      order: 0,
      code: 'ERIRI',
      name: '泽村·斯宾塞·英梨梨',
      tags: ['路人女主的养成方法', '金发', '败犬'],
      video_link: '//cdn.yuanlimm.com/eriri.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29775778&auto=0&height=66'
    )
    Stock.create!(
      order: 1,
      code: 'UTAHA',
      name: '霞之丘诗羽',
      tags: ['路人女主的养成方法', '黑丝', '学姐'],
      video_link: '//cdn.yuanlimm.com/utaha.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29775784&auto=0&height=66'
    )
    Stock.create!(
      order: 2,
      code: 'KM',
      name: '加藤惠',
      tags: ['路人女主的养成方法', '天降'],
      video_link: '//cdn.yuanlimm.com/kato.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29775810&auto=0&height=66'
    )
    Stock.create!(
      order: 3,
      code: 'ATAGOKC',
      name: '愛宕さん',
      tags: ['舰队Collection'],
      video_link: '//cdn.yuanlimm.com/atago.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=41662342&auto=0&height=66'
    )
    Stock.create!(
      order: 4,
      code: 'SABER',
      name: '阿尔托莉雅·潘德拉贡',
      tags: ['Fate', '月球', 'Saber'],
      video_link: '//cdn.yuanlimm.com/saber.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=448119&auto=0&height=66'
    )
    Stock.create!(
      order: 5,
      code: 'RIN',
      name: '远坂凛',
      tags: ['Fate', '月球', '黑丝'],
      video_link: '//cdn.yuanlimm.com/rin.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=667360&auto=0&height=66'
    )
    Stock.create!(
      order: 6,
      code: 'MTSAKURA',
      name: '间桐樱',
      tags: ['Fate', '月球', '学妹'],
      video_link: '//cdn.yuanlimm.com/mtsakura.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=514543467&auto=0&height=66'
    )
    Stock.create!(
      order: 7,
      code: 'IRIYA',
      name: '伊莉雅斯菲尔·冯·爱因兹贝伦',
      tags: ['Fate', '月球', '妹妹', '魔法少女', '萝莉'],
      video_link: '//cdn.yuanlimm.com/iriya.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=35283039&auto=0&height=66'
    )
    Stock.create!(
      order: 8,
      code: 'EDSION',
      name: '诗音（eden*）',
      tags: ['eden*', '萝莉', '女神'],
      video_link: '//cdn.yuanlimm.com/sion.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=527501&auto=0&height=66'
    )
    Stock.create!(
      order: 9,
      code: 'YUANLIMM',
      name: '新子憧',
      tags: ['天才麻将少女', '援力满满'],
      video_link: '//cdn.yuanlimm.com/ago.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=664066&auto=0&height=66'
    )
    Stock.create!(
      order: 10,
      code: 'TSUBASA',
      name: '羽川翼',
      tags: ['物语系列', '学姐'],
      video_link: '//cdn.yuanlimm.com/tsubasa.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=28048770&auto=0&height=66'
    )
    Stock.create!(
      order: 11,
      code: 'GWHITE',
      name: '天真·珈百璃·怀特',
      tags: ['珈百璃的堕落', '金发'],
      video_link: '//cdn.yuanlimm.com/white.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=461332138&auto=0&height=66'
    )
    Stock.create!(
      order: 12,
      code: 'ISLA',
      name: '艾拉',
      tags: ['可塑性记忆'],
      video_link: '//cdn.yuanlimm.com/isla.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=38019747&auto=0&height=66'
    )
    Stock.create!(
      order: 13,
      code: 'HUGH',
      name: '叶修',
      tags: ['全职高手', '男人'],
      video_link: '//cdn.yuanlimm.com/hugh.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=468476803&auto=0&height=66'
    )
    Stock.create!(
      order: 14,
      code: 'ASTOLFO',
      name: '阿斯托尔福',
      tags: ['Fate', '月球', '伪娘'],
      video_link: '//cdn.yuanlimm.com/astolfo.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=501142408&auto=0&height=66'
    )
    Stock.create!(
      order: 15,
      code: 'MYUKI',
      name: '森川由绮',
      tags: ['白色相簿1', '白学'],
      video_link: '//cdn.yuanlimm.com/yuki.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=32303030&auto=0&height=66'
    )
    Stock.create!(
      order: 16,
      code: 'NIA',
      name: '妮亚',
      tags: ['天元突破', '公主'],
      video_link: '//cdn.yuanlimm.com/nia.mp4',
    )
    Stock.create!(
      order: 17,
      code: 'YOSE',
      name: '妖精桑',
      tags: ['人类衰退之后'],
      video_link: '//cdn.yuanlimm.com/yose.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26215827&auto=0&height=66'
    )
    Stock.create!(
      order: 18,
      code: 'CHIHUO',
      name: '洛天依',
      tags: ['Vocaloid', 'V家'],
      video_link: '//cdn.yuanlimm.com/chihuo.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=359939&auto=0&height=66'
    )
    Stock.create!(
      order: 19,
      code: 'HIROMI',
      name: '汤浅比吕美',
      tags: ['真实之泪'],
      video_link: '//cdn.yuanlimm.com/hiromi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26214881&auto=0&height=66'
    )
    Stock.create!(
      order: 20,
      code: 'ERINA',
      name: '薙切绘里奈',
      tags: ['食戟之灵'],
      video_link: '//cdn.yuanlimm.com/erina.mp4',
    )
    Stock.create!(
      order: 21,
      code: 'BILIBILI',
      name: '御坂美琴',
      tags: ['魔法禁书目录'],
      video_link: '//cdn.yuanlimm.com/bilibili.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=440207759&auto=0&height=66'
    )
    Stock.create!(
      order: 22,
      code: 'NAMEPTUNE',
      name: '涅普迪努',
      tags: ['超次元游戏', '女神'],
      video_link: '//cdn.yuanlimm.com/nameptune.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=29027278&auto=0&height=66'
    )
    Stock.create!(
      order: 23,
      code: 'UC207',
      name: '朱碧·多拉',
      tags: ['NO GAME NO LIFE'],
      video_link: '//cdn.yuanlimm.com/uc207.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=490182455&auto=0&height=66'
    )
    Stock.create!(
      order: 24,
      code: 'FUUKA',
      name: '秋月风夏',
      tags: ['凉风'],
      video_link: '//cdn.yuanlimm.com/fuuka.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=483905695&auto=0&height=66'
    )
    Stock.create!(
      order: 25,
      code: 'MIKU',
      name: '初音未来',
      tags: ['Vocaloid', 'V家'],
      video_link: '//cdn.yuanlimm.com/miku.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26115904&auto=0&height=66'
    )
    Stock.create!(
      order: 26,
      code: 'CHINO',
      name: '香风智乃',
      tags: ['请问您今天要来点兔子吗？', '萝莉'],
      video_link: '//cdn.yuanlimm.com/chino.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=437605134&auto=0&height=66'
    )
    Stock.create!(
      order: 27,
      code: 'REIMU',
      name: '博丽灵梦',
      tags: ['东方Project'],
      video_link: '//cdn.yuanlimm.com/reimu.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=22636684&auto=0&height=66'
    )
    Stock.create!(
      order: 28,
      code: 'HARUHI',
      name: '凉宫春日',
      tags: ['凉宫春日系列'],
      video_link: '//cdn.yuanlimm.com/haruhi.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=22826425&auto=0&height=66'
    )
    Stock.create!(
      order: 29,
      code: 'TAIGA',
      name: '逢坂大河',
      tags: ['龙与虎', '金发', '萝莉', '钉宫'],
      video_link: '//cdn.yuanlimm.com/taiga.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=583281&auto=0&height=66'
    )
    Stock.create!(
      order: 30,
      code: 'HAI',
      name: '雏鹤爱',
      tags: ['龙王的工作！', '萝莉', '天降'],
      video_link: '//cdn.yuanlimm.com/hai.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=534064232&auto=0&height=66'
    )
    Stock.create!(
      order: 31,
      code: 'NANAMI',
      name: '七海千秋',
      tags: ['弹丸论破'],
      video_link: '//cdn.yuanlimm.com/nanami.mp4',
    )
    Stock.create!(
      order: 32,
      code: 'SAKI',
      name: '宫永咲',
      tags: ['天才麻将少女'],
      video_link: '//cdn.yuanlimm.com/saki.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=578758&auto=0&height=66'
    )
    Stock.create!(
      order: 33,
      code: 'MOMO',
      name: '茉茉‧贝莉雅‧戴比路克',
      tags: ['出包王女'],
      video_link: '//cdn.yuanlimm.com/momo.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26219806&auto=0&height=66'
    )
    Stock.create!(
      order: 34,
      code: 'REINA',
      name: '高坂丽奈',
      tags: ['吹响！上低音号'],
      video_link: '//cdn.yuanlimm.com/reina.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=33051090&auto=0&height=66'
    )
    Stock.create!(
      order: 35,
      code: 'SERENA',
      name: '瑟蕾娜',
      tags: ['精灵宝可梦'],
      video_link: '//cdn.yuanlimm.com/serena.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=440101054&auto=0&height=66'
    )
    Stock.create!(
      order: 36,
      code: 'ERU',
      name: '千反田爱瑠',
      tags: ['冰菓'],
      video_link: '//cdn.yuanlimm.com/eru.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=26214813&auto=0&height=66'
    )
    Stock.create!(
      order: 37,
      code: 'AQUA',
      name: '阿库娅',
      tags: ['为美好的世界献上祝福！'],
      video_link: '//cdn.yuanlimm.com/aqua.mp4',
      music_link: '//music.163.com/outchain/player?type=2&id=457337588&auto=0&height=66'
    )
  end
end
