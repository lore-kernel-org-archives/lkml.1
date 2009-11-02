Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbZKBHkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbZKBHkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZKBHkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:40:11 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.28]:42175 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZKBHkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:40:10 -0500
Message-ID: <4AEE8CDD.10600@ladisch.de>
Date: Mon, 02 Nov 2009 08:40:13 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>
CC: dri-devel@lists.sourceforge.net, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] DRM/KMS framebuffer fixes
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches make the KMS framebuffer work with various programs like
links, mplayer and X.

 drivers/gpu/drm/drm_fb_helper.c    |    6 +++---
 drivers/gpu/drm/i915/intel_fb.c    |    5 +++++
 drivers/gpu/drm/radeon/radeon_fb.c |    5 +++++
 3 files changed, 13 insertions(+), 3 deletions(-)
