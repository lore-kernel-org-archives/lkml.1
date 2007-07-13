Return-Path: <linux-kernel-owner+w=401wt.eu-S937791AbXGMW5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937791AbXGMW5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbXGMW5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:57:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:56355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbXGMW52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:57:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,538,1175497200"; 
   d="scan'208";a="266004544"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue take3
Date: Fri, 13 Jul 2007 15:57:26 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5202234462@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070713155400.24689606.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue take3
Thread-Index: AcfFoLjchCJC3+SuRiuoz5w4AV80hgAADQmA
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <neilb@suse.de>, <raziebe@gmail.com>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Jul 2007 22:57:27.0111 (UTC) FILETIME=[2EEE1570:01C7C5A1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > The following patches replace the stripe-queue patches currently in
-mm.
> 
> I have a little practical problem here: am presently unable to compile
> anything much due to all the git rejects coming out of
git-md-accel.patch.
> 
> It'd be appreciated if you could keep on top of that, please.  It's a
common
> problem at this time of the kernel cycle.  The quilt trees are much
worse -
> Greg's
> stuff is an unholy mess.  Ho hum.

Sorry, please drop git-md-accel.patch and git-ioat.patch as they have
been merged into Linus' tree.
