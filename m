Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZA1UTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZA1UTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZA1UTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:19:42 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:38405 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZA1UTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:19:42 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: tiwai@suse.de
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] AC97: Fix function name type in comment s/updat/update/
Date: Wed, 28 Jan 2009 18:20:06 -0200
Message-Id: <1233174006-16210-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 sound/pci/ac97/ac97_codec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index e2b843b..27551e9 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -383,7 +383,7 @@ int snd_ac97_update_bits(struct snd_ac97 *ac97, unsigned short reg, unsigned sho
 
 EXPORT_SYMBOL(snd_ac97_update_bits);
 
-/* no lock version - see snd_ac97_updat_bits() */
+/* no lock version - see snd_ac97_update_bits() */
 int snd_ac97_update_bits_nolock(struct snd_ac97 *ac97, unsigned short reg,
 				unsigned short mask, unsigned short value)
 {
-- 
1.6.0.6

