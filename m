Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbYGNX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbYGNX5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbYGNX5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:57:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:58669 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759958AbYGNX5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:57:20 -0400
Date: Tue, 15 Jul 2008 08:56:50 +0900
To: mingo@elte.hu
Cc: muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: IOMMU cleanups
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080711090149.GA22533@elte.hu>
References: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080711082303.GA6955@il.ibm.com>
	<20080711090149.GA22533@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080715085654L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 11:01:49 +0200
Ingo Molnar <mingo@elte.hu> wrote:

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

This missed the merge window? It's not urgent at all but it's clean
and pretty safe, I think.
