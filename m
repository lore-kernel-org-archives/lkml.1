Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZDOCmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZDOCmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbZDOCml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:42:41 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:60131 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbZDOCmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:42:40 -0400
X-Greylist: delayed 1703 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 22:42:40 EDT
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/2] Trivial: fix typo s/balence/balance/
Date: Tue, 14 Apr 2009 23:14:17 -0300
Message-Id: <1239761657-16555-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 include/linux/ultrasound.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ultrasound.h b/include/linux/ultrasound.h
index 6b7703e..71339dc 100644
--- a/include/linux/ultrasound.h
+++ b/include/linux/ultrasound.h
@@ -34,7 +34,7 @@
  *		_GUS_VOICEOFF	- Stops voice (no parameters)
  *		_GUS_VOICEFADE	- Stops the voice smoothly.
  *		_GUS_VOICEMODE	- Alters the voice mode, don't start or stop voice (P1=voice mode)
- *		_GUS_VOICEBALA	- Sets voice balence (P1, 0=left, 7=middle and 15=right, default 7)
+ *		_GUS_VOICEBALA	- Sets voice balance (P1, 0=left, 7=middle and 15=right, default 7)
  *		_GUS_VOICEFREQ	- Sets voice (sample) playback frequency (P1=Hz)
  *		_GUS_VOICEVOL	- Sets voice volume (P1=volume, 0xfff=max, 0xeff=half, 0x000=off)
  *		_GUS_VOICEVOL2	- Sets voice volume (P1=volume, 0xfff=max, 0xeff=half, 0x000=off)
-- 
1.6.2.2

