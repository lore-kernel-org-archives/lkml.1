Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbYHJWw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbYHJWw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYHJWwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:52:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:20944 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYHJWwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bjkSdtv+pP+giktBlPqgN9Fi/e61ET8Xv6ScEkvahfo9/mW5lRUk5tLJ5XEauzWljT
         7xAoRLNdEGiznYzAKvBPmafQelQvzcdtb8+RUmjM25kSGH0jRsY89A732KLUi8gto4Dg
         TWXoKzbxsb3cm1bNHXXSJ4oApUOP33nogTd9o=
Date: Mon, 11 Aug 2008 02:52:42 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/pci/Kconfig: update for ice1712/24
Message-ID: <20080810225242.GE5093@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

sound/pci/Kconfig: update for ice1712/24


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 sound/pci/Kconfig |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index f7d95b2..e14dc54 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -649,8 +649,9 @@ config SND_ICE1712
 
 	  Currently supported hardware is: M-Audio Delta 1010(LT),
 	  DiO 2496, 66, 44, 410, Audiophile 24/96; Digigram VX442;
-	  TerraTec EWX 24/96, EWS 88MT, 88D, DMX 6Fire, Phase 88;
-	  Hoontech SoundTrack DSP 24/Value/Media7.1; Event EZ8.
+	  TerraTec EWX 24/96, EWS 88MT/D, DMX 6Fire, Phase 88;
+	  Hoontech SoundTrack DSP 24/Value/Media7.1; Event EZ8;
+	  Lionstracs Mediastation, Terrasoniq TS 88.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-ice1712.
@@ -665,9 +666,12 @@ config SND_ICE1724
 	  ICE/VT1724/1720 (Envy24HT/PT) chips.
 
 	  Currently supported hardware is: AMP AUDIO2000; M-Audio
-	  Revolution 7.1; TerraTec Aureon 5.1 Sky, 7.1 Space/Universe;
-	  AudioTrak Prodigy 7.1; Pontis MS300; Albatron K8X800 Pro II;
-	  Chaintech ZNF3-150/250.
+	  Revolution 5.1, 7.1, Audiophile 192; TerraTec Aureon 5.1 Sky,
+	  7.1 Space/Universe, Phase 22/28; Onkyo SE-90PCI, SE-200PCI;
+	  AudioTrak Prodigy 192, 7.1 (HIFI/LT/XT), HD2; Hercules
+	  Fortissimo IV; ESI Juli@; Pontis MS300; EGO-SYS WaveTerminal
+	  192M; Albatron K8X800 Pro II; Chaintech ZNF3-150/250, 9CJS,
+	  AV-710; Shuttle SN25P.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-ice1724.
