Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZDWHnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZDWHnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbZDWHar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:47 -0400
Received: from sous-sol.org ([216.99.217.87]:50496 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755474AbZDWHaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:46 -0400
Message-Id: <20090423072616.748065721@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Akinobu Mita <akinobu.mita@gmail.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 051/100] ALSA: hda - add missing comma in ad1884_slave_vols
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=alsa-hda-add-missing-comma-in-ad1884_slave_vols.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

upstream commit: bca68467b59a24396554d8dd5979ee363c174854

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 sound/pci/hda/patch_analog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3239,7 +3239,7 @@ static const char *ad1884_slave_vols[] =
 	"Mic Playback Volume",
 	"CD Playback Volume",
 	"Internal Mic Playback Volume",
-	"Docking Mic Playback Volume"
+	"Docking Mic Playback Volume",
 	"Beep Playback Volume",
 	"IEC958 Playback Volume",
 	NULL

