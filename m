Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbXEJKRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbXEJKRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760052AbXEJKON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:14:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977AbXEJKOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:14:03 -0400
Message-Id: <20070510100839.621199408@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 12:08:39 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 00/15] per device dirty throttling -v6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The latest version of the per device dirty throttling patches.

I put in quite a few comments, and added an patch to do per task dirty
throttling as well, for RFCs sake :-)

I haven't yet come around to do anything but integrety testing on this code
base, ie. it built a kernel. I hope to do more tests shorty if time permits...

Perhaps the people on bugzilla.kernel.org #7372 might be willing to help out
there.

Oh, patches are against 2.6.21-mm2

-- 

