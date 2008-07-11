Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYGKMh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYGKMh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYGKMhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:37:14 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:49721 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYGKMhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:37:12 -0400
Date: Fri, 11 Jul 2008 15:36:10 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: IOMMU cleanups
Message-ID: <20080711123610.GC6955@il.ibm.com>
References: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080711082303.GA6955@il.ibm.com> <20080711090149.GA22533@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711090149.GA22533@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 11:01:49AM +0200, Ingo Molnar wrote:
> 
> * Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> 
> > On Fri, Jul 11, 2008 at 10:23:41AM +0900, FUJITA Tomonori wrote:
> > > This patchset cleans up IOMMU stuff, including a sequel to the GART
> > > cleanups:
> > > 
> > > http://lkml.org/lkml/2008/7/9/488
> > > 
> > > This is against tip/master.
> > 
> > I heartily endorse this patchset. Thanks for doing it!
> 
> thanks - the series looks really nice and i've applied it to
> tip/x86/gart.
> 
> I've also added:
> 
>   Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> ... if you dont mind.

I don't mind at all. 

(the reason I didn't ack it at first is that I try to review *and*
test a patchset first before formally acking it...)

Cheers,
Muli
