Return-Path: <linux-kernel-owner+w=401wt.eu-S1765769AbZD3RVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765769AbZD3RVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764604AbZD3RHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:48 -0400
Received: from kroah.org ([198.145.64.141]:56384 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764544AbZD3RHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:43 2009
Message-Id: <20090430165742.913310552@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       Takashi Iwai <tiwai@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 31/88] ALSA: hda - add missing comma in ad1884_slave_vols
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0050-ALSA-hda-add-missing-comma-in-ad1884_slave_vols.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

upstream commit: bca68467b59a24396554d8dd5979ee363c174854

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_analog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3233,7 +3233,7 @@ static const char *ad1884_slave_vols[] =
 	"Mic Playback Volume",
 	"CD Playback Volume",
 	"Internal Mic Playback Volume",
-	"Docking Mic Playback Volume"
+	"Docking Mic Playback Volume",
 	"Beep Playback Volume",
 	"IEC958 Playback Volume",
 	NULL


