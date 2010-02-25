Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0BYEoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:44:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab0BYEoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:44:17 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: fb fix + laptop gpu switching support
Date: Thu, 25 Feb 2010 14:44:25 +1000
Message-Id: <1267073067-23117-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch is a trivial change to the fb handover code.

The second adds initial support framework for laptops with GPU switching
features, it has some changes to fb code, along with changes to dri
drivers.

I'm happy to deal with these patches via drm-2.6 for this merge window
if nobody has any objections.

Dave.

