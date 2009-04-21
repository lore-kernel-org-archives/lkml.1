Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZDUVHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZDUVHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZDUVHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:07:33 -0400
Received: from c60.cesmail.net ([216.154.195.49]:21643 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZDUVHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:07:32 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] intelfb: fix spelling of "CLOCK"
To: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 21 Apr 2009 17:07:30 -0400
Message-ID: <20090421210730.10927.73712.stgit@mj.roinet.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/gpu/drm/i915/intel_fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 3e094be..4b6d463 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -207,7 +207,7 @@ static int intelfb_set_par(struct fb_info *info)
 
 	if (var->pixclock != -1) {
 
-		DRM_ERROR("PIXEL CLCOK SET\n");
+		DRM_ERROR("PIXEL CLOCK SET\n");
 		return -EINVAL;
 	} else {
 		struct drm_crtc *crtc;
