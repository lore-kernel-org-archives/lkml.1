Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZDNVhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZDNVhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZDNVhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:37:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:30016 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZDNVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JwNwlGZfUA8KzhRGtBw2s/SoarvYY17/3Xk0MmXrEHueLyRn09tsTyLRr6CB4WdGoc
         Z6OUFT7NJC6xcZMblhMrCoYN0unykJZFuTr2OtD7d0FqRvbCxFZe4IFWI3W+XTuvPAKy
         MtFBlrqAiLk+tQuAhAHD/F0hILxuEp4kgT/+U=
MIME-Version: 1.0
Date: Tue, 14 Apr 2009 14:31:21 -0700
Message-ID: <dd18b0c30904141431x231a3251v438e365d512f9f95@mail.gmail.com>
Subject: [PATCH] add missing definitions(letters) to HD-Audio.txt
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

impact: Add missing definitions(letters).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/HD-Audio.txt | 3 +++
 1 files changed,3 insertions(+),0 deletions(-)

===========================================================================================
---- Documentation/sound/alsa/HD-Audio.txt        2009-04-14
17:03:14.000000000 -0700
++++ Documentation/sound/alsa/HD-Audio.txt        2009-04-14
21:15:22.000000000 -0700
@@ -162,7 +162,7 @@
 What `model` option values are available depends on the codec chip.
 Check your codec chip from the codec proc file (see "Codec Proc-File"
 section below).  It will show the vendor/product name of your codec
-chip.  Then, see Documentation/sound/alsa/HD-Audio-Modelstxt file,
+chip.  Then, see Documentation/sound/alsa/HD-Audio-Models.txt file,
 the section of HD-audio driver.  You can find a list of codecs
 and `model` options belonging to each codec.  For example, for Realtek
 ALC262 codec chip, pass `model=ultra` for devices that are compatible
@@ -170,7 +170,7 @@

 Thus, the first thing you can do for any brand-new, unsupported and
 non-working HD-audio hardware is to check HD-audio codec and several
-different `model` option values.  If you have a luck, some of them
+different `model` option values.  If you have any luck, some of them
 might suit with your device well.

 Some codecs such as ALC880 have a special model option `model=test`.



-- 
Justin P. Mattock
