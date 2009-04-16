Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZDPGjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZDPGjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZDPGi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:38:58 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2794 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZDPGi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:38:57 -0400
Subject: [PATCH] MAINTAINERS - Update SOUND
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
In-Reply-To: <s5h8wm12jts.wl%tiwai@suse.de>
References: <1239821506.26340.199.camel@localhost>
	 <s5h8wm12jts.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 23:38:45 -0700
Message-Id: <1239863925.14053.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0cb20d8..c81792f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5184,13 +5184,17 @@ F:	drivers/memstick/host/tifm_ms.c
 SOUND
 P:	Jaroslav Kysela
 M:	perex@perex.cz
 P:	Takashi Iwai
 M:	tiwai@suse.de
 L:	alsa-devel@alsa-project.org (subscribers-only)
+W:	http://www.alsa-project.org/main/index.php/Main_Page
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
 S:	Maintained
+F:	Documentation/sound/
+F:	include/sound/
 F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
 P:	Liam Girdwood
 M:	lrg@slimlogic.co.uk
 P:	Mark Brown


