Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZDFJnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZDFJnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZDFJmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:42:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:12296 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZDFJmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ECGIyTtTo5Nubc0ajbav2sUL+jEm3CTUR9AKvrjif9P7P6UKJ5jTGxxaDZq5DWoruQ
         i7Sq00Hyq7hWk4j2F50HTudoLllkGwsbvAxN3tJTnYDBA+kPeMHGt6y7x+wDvo7efNOp
         R9rEP+nrYvJldaj8vEAbYIPJavZKb3Q16ug6g=
Date: Mon, 6 Apr 2009 18:42:42 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda - add missing comma in ad1884_slave_vols
Message-ID: <20090406094242.GA4139@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/hda/patch_analog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 5bb48ee..38ad3f7 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3256,7 +3256,7 @@ static const char *ad1884_slave_vols[] = {
 	"Mic Playback Volume",
 	"CD Playback Volume",
 	"Internal Mic Playback Volume",
-	"Docking Mic Playback Volume"
+	"Docking Mic Playback Volume",
 	/* "Beep Playback Volume", */
 	"IEC958 Playback Volume",
 	NULL
