Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbZHXB4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbZHXB4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZHXBz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:55:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51969 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZHXBz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:55:59 -0400
Date: Mon, 24 Aug 2009 02:56:02 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] minor drm fix for kms busy.
Message-ID: <alpine.DEB.2.00.0908240255050.18106@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1699853722-1251078962=:18106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1699853722-1251078962=:18106
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Dave.

 drivers/gpu/drm/radeon/radeon_gem.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

commit 9f844e5118d1627025c8ea7cfc0ea69038ea63fd
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Sat Aug 22 17:38:23 2009 +0200

    drm/radeon/kms: Fix radeon_gem_busy_ioctl harder.
    
    It was mixing up TTM placement values and flags.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-1699853722-1251078962=:18106--
