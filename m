Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZALIht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZALIht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZALIhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:37:40 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:37935 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZALIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:37:40 -0500
Date: Mon, 12 Jan 2009 14:07:34 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-mm@kvack.org,
       sfr@canb.auug.org.au, benh@kernel.crashing.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, mel@csn.ul.ie
Subject: Re: [BUG] 2.6.28-git-4 - powerpc - kernel expection 'c01 at
	.kernel_thread'
Message-ID: <20090112083734.GB8409@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090102125752.GA5743@linux.vnet.ibm.com> <200901110108.20848.rjw@sisk.pl> <20090112072132.GA8409@linux.vnet.ibm.com> <200901120907.20418.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200901120907.20418.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2009-01-12 09:07:19]:

> On Monday 12 January 2009, Kamalesh Babulal wrote:
> > * Rafael J. Wysocki <rjw@sisk.pl> [2009-01-11 01:08:19]:
> > 
> > > On Friday 02 January 2009, Kamalesh Babulal wrote:
> > > > Hi,
> > > > 
> > > > 	2.6.28-git4 kernel drops to xmon with kernel expection. Similar kernel
> > > > expection was seen next-20081230 and next-20081231 and was reported 
> > > > earlier at http://lkml.org/lkml/2008/12/31/157
> > > 
> > > Is this a regression from 2.6.27?
> > > 
> > > Rafael
> > >
> > 
> > This is not a regression from 2.6.27, this expection was first seen 
> > next-20081230 patches and then was introduced into 2.6.28-git4 and is 
> > reproducible with 2.6.28-rc1 kernel.
> 
> Presumably you meant 2.6.29-rc1 ?  In which case it would be a regression from
> 2.6.28 .  Please confirm.
> 
> Thanks,
> Rafael
> 
sorry, I meant it was introduced in 2.6.28-git4 and is still reproducible
with 2.6.29-rc1.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
