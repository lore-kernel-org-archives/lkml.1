Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZCDLxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZCDLxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZCDLxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:53:45 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53395 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZCDLxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:53:44 -0500
Date: Wed, 4 Mar 2009 11:53:42 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm stupidity fixes
Message-ID: <alpine.DEB.2.00.0903041152150.27334@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

^lock^unlock, the API isn't in much use yet outside of Fedora so wasn't 
spotted.

Dave.

 drivers/gpu/drm/drm_stub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 5ad8b7d12605e88d1e532061699102797fdefe08
Author: Helge Bahmann <helge.bahmann@secunet.com>
Date:   Wed Mar 4 21:49:14 2009 +1000

    drm: fix double lock typo
    
    [airlied: you shall not retype patches from other trees half asleep]
    
    Signed-of-by: Dave Airlie <airlied@redhat.com>

