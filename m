Return-Path: <linux-kernel-owner+w=401wt.eu-S940674AbXHMKrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940674AbXHMKrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967340AbXHMGgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1886 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967333AbXHMGg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:26 -0400
Date: Sun, 12 Aug 2007 23:36:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, perex@suse.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [447/2many] MAINTAINERS - SOUND
Message-ID: <46bffbdd.Jx66n5clJOgCO7yj%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4d9d9..c27dc46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4249,6 +4249,7 @@ P:	Jaroslav Kysela
 M:	perex@suse.cz
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Maintained
+F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT
 P:	Liam Girdwood
