Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbYG1Qzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbYG1Qzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYG1Qza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:55:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:44089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYG1Qza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:55:30 -0400
Date: Mon, 28 Jul 2008 09:47:47 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: move ehci reg def
Message-ID: <20080728164747.GA31120@kroah.com>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231739.39620.yhlu.kernel@gmail.com> <200807241727.57692.yhlu.kernel@gmail.com> <200807241757.23441.david-b@pacbell.net> <86802c440807241914o3e09a1a2la1cf9345b4b0e52b@mail.gmail.com> <20080726141813.GG4401@elte.hu> <20080728154042.GC30206@kroah.com> <20080728161102.GA18860@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728161102.GA18860@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 06:11:02PM +0200, Ingo Molnar wrote:
> * Greg KH <greg@kroah.com> wrote:
> > I have no objection for you keeping this in your tree, as that 
> > probably makes it easier.
> 
> okay - i just wanted to keep your options maximally flexible, it's code 
> you maintain, we are just trespassing :)
> 
> the commit will eventually show up in linux-next via tip/auto-x86-next. 
> 
> Given that it's all pretty uncontroversial, we might as well send it 
> upstream after -rc1 - this is an isolated debug feature. (and a much 
> desired one to begin with. We could even get printks out of terminally 
> hung suspend/resume laptops this way i think!)
> 
> Any objections to that course of action?

No objections from me at all, I would like to see this code finaly get
moved into the tree.

thanks for doing this.

greg k-h
