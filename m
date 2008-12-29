Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYL2H0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYL2H0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 02:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYL2H0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 02:26:42 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36178 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYL2H0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 02:26:41 -0500
Date: Mon, 29 Dec 2008 07:26:39 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] AGP
Message-ID: <alpine.DEB.2.00.0812290723320.20427@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-777585004-1230535599=:20427"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-777585004-1230535599=:20427
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'agp-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-next

Just a minor fix + new PCI ID.

Dave.

 drivers/char/agp/intel-agp.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

commit b854b2ab959e8175d75e01cf8ed452ed2624d0c8
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Dec 22 18:56:27 2008 -0800

    agp/intel: Fix broken ® symbol in device name.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit a50ccc6c6623ab0e64f2109881e07c176b2d876f
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Mon Nov 17 14:39:00 2008 +0800

    agp/intel: add support for G41 chipset
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-777585004-1230535599=:20427--
