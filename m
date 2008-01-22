Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYAVFV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYAVFV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYAVFVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:21:49 -0500
Received: from mx1.suse.de ([195.135.220.2]:59828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYAVFVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:21:48 -0500
Date: Mon, 21 Jan 2008 21:15:05 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080122051505.GA7619@suse.de>
References: <a8e1da0801210044t5f705f77n8e310878775f7b5b@mail.gmail.com> <20080121211625.GA2758@ami.dom.local> <a8e1da0801211655y5a7313edn331ad4312b0b7de9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801211655y5a7313edn331ad4312b0b7de9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 08:55:05AM +0800, Dave Young wrote:
> On Jan 22, 2008 5:16 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> > Dave Young wrote, On 01/21/2008 09:44 AM:
> > ...
> > > I applied it in my kernel, built and run without warnings, but it need
> > > more testing.
> > > I will be very glad to see the test result about this if you could, thanks.
> >
> > Bad news. (Alas I won't be able to check this today.)
> 
> Hi, thanks your effort. Now I think we should stop this thread and
> waiting the class_device going away :)
> 
> Hope the iteration patches 1-6/7 could be applied.

Can you resend them again, and CC: me on all of them, with the latest
updates, so I know what I should be reviewing this time around?

thanks,

greg k-h
