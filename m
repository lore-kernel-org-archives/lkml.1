Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYFTBxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYFTBxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 21:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYFTBxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 21:53:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49157 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYFTBxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 21:53:13 -0400
Date: Fri, 20 Jun 2008 02:53:12 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp one missing intel patch..
Message-ID: <alpine.DEB.0.82.0806200252150.12492@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

Missed a chunk, no more hand applying whitespace damaged patches either.

Dave.

 drivers/char/agp/intel-agp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 7d15ddf79ec35ce79093832c80b86c0888eb5bce
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Fri Jun 20 11:48:06 2008 +1000

    [agp]: fixup chipset flush for new Intel G4x.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
