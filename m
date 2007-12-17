Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbXLQUfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbXLQUfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933527AbXLQUeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:34:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:60860 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458AbXLQUeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:34:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: minchan kim <minchan.kim@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/7] HOWTO: change addresses of maintainer and lxr url for Korean HOWTO
Date: Mon, 17 Dec 2007 12:33:21 -0800
Message-Id: <1197923603-6752-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <20071217185654.GC4330@kroah.com>
References: <20071217185654.GC4330@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: minchan kim <minchan.kim@gmail.com>

So sorry. again My mail is set with EUC-kR.
I'll resend with UTF-8.

Signed-off-by: barrios <minchan.kim@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ko_KR/HOWTO |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index b51d7ca..a69135b 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -90,7 +90,7 @@ GPL에 관한 잦은 질문들과 답변들은 다음을 참조하라.
 그 기능을 어떻게 사용하는지에 관한 설명을 위하여 새로운 문서 파일을
 추가하는 것을 권장한다. 커널이 유저스페이스로 노출하는 인터페이스를
 변경하게 되면 변경을 설명하는 메뉴얼 페이지들에 대한 패치나 정보를
-mtk-manpages@gmx.net의 메인트너에게 보낼 것을 권장한다.
+mtk.manpages@gmail.com의 메인트너에게 보낼 것을 권장한다.
 
 다음은 커널 소스 트리에 있는 읽어야 할 파일들의 리스트이다.
   README
@@ -212,7 +212,7 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
 것은 Linux Cross-Reference project이며 그것은 자기 참조 방식이며
 소스코드를 인덱스된 웹 페이지들의 형태로 보여준다. 최신의 멋진 커널
 코드 저장소는 다음을 통하여 참조할 수 있다.
-      http://sosdg.org/~coywolf/lxr/
+      http://users.sosdg.org/~qiyong/lxr/
 
 
 개발 프로세스
@@ -327,7 +327,7 @@ Andrew Morton에 의해 배포된 실험적인 커널 패치들이다. Andrew는
     - ACPI development tree, Len Brown <len.brown@intel.com >
     git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 
-    - Block development tree, Jens Axboe <axboe@suse.de>
+    - Block development tree, Jens Axboe <jens.axboe@oracle.com>
     git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 
     - DRM development tree, Dave Airlie <airlied@linux.ie>
-- 
1.5.3.7

