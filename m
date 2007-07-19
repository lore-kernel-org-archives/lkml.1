Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbXGSDLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbXGSDLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXGSDLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:11:33 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40707 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbXGSDLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:11:32 -0400
Message-Id: <469ED62C.2050401@ds.jp.nec.com>
Date: Thu, 19 Jul 2007 12:10:36 +0900
From: IKEDA Munehiro <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: ja, en-us, en
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Subject: Re: [PATCH 2/5] Documentation: add Japanese translated stable_api_nonsense.txt
References: <20070718232346.GB4620@kroah.com>	 <11848012031961-git-send-email-gregkh@suse.de> <9a8748490707181643v2ad6b0d0ld44226a367a6f937@mail.gmail.com>
In-Reply-To: <9a8748490707181643v2ad6b0d0ld44226a367a6f937@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 19/07/07, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
>>From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
>>
>>Add the japanese translation of the Documentation/HOWTO file.
>>
> 
> 
> A few comments below.
(snip)

Thank Jesper for the comments.
Below is a patch for Japanese stable_api_nonsense.txt against
patch posted by Greg.
It adjusts the translation header to follow your comments.

Greg, if patch-against-patch is not preferable, please notice me.
If so, I'll make a full-body patch and re-submit.


>From d9081aabf9335e8d8a3dbefe60f6883995fa6af5 Mon Sep 17 00:00:00 2001
From: IKEDA, Munehiro <m-ikeda@ds.jp.nec.com>
Date: Thu, 19 Jul 2007 11:36:56 +0900
Subject: [PATCH] adjust translation header of Japanese stable_api_nonsense.txt


Signed-off-by: IKEDA, Munehiro <m-ikeda@ds.jp.nec.com>
---
 Documentation/ja_JP/stable_api_nonsense.txt |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/ja_JP/stable_api_nonsense.txt b/Documentation/ja_JP/stable_api_nonsense.txt
index b3f2b27..7653b5c 100644
--- a/Documentation/ja_JP/stable_api_nonsense.txt
+++ b/Documentation/ja_JP/stable_api_nonsense.txt
@@ -1,17 +1,17 @@
 NOTE:
-This is a Japanese translated version of
-"Documentation/stable_api_nonsense.txt".
-This one is maintained by
-IKEDA, Munehiro <m-ikeda@ds.jp.nec.com>
-and JF Project team <http://www.linux.or.jp/JF/>.
-If you find difference with original file or problem in translation,
+This is a version of Documentation/stable_api_nonsense.txt into Japanese.
+This document is maintained by IKEDA, Munehiro <m-ikeda@ds.jp.nec.com>
+and the JF Project team <http://www.linux.or.jp/JF/>.
+If you find any difference between this document and the original file
+or a problem with the translation,
 please contact the maintainer of this file or JF project.
 
-Please also note that purpose of this file is easier to read for non
-English natives and not to be intended to fork. So, if you have any
-comments or updates of this file, please try to update
-Original(English) file at first.
+Please also note that the purpose of this file is to be easier to read
+for non English (read: Japanese) speakers and is not intended as a
+fork. So if you have any comments or updates of this file, please try
+to update the original English file first.
 
+Last Updated: 2007/07/18
 ==================================
 縺薙ｌ縺ｯ縲・
 linux-2.6.22-rc4/Documentation/stable_api_nonsense.txt 縺ｮ蜥瑚ｨｳ
-- 
1.4.4.4

