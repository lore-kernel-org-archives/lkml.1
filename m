Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbXHXSKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbXHXSKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762267AbXHXSJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:09:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:59445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933339AbXHXSJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:09:46 -0400
Date: Fri, 24 Aug 2007 11:08:33 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>
Cc: linux-usb-devel@lists.sourceforge.net
Subject: Re: [4/4] 2.6.23-rc3: known regressions v3
Message-ID: <20070824180833.GA14415@suse.de>
References: <46CF0DEF.5040107@googlemail.com> <46CF17A0.2060503@googlemail.com> <20070824175608.GA5333@suse.de> <20070824180120.GA13916@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824180120.GA13916@dose.home.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 08:01:20PM +0200, Tino Keitel wrote:
> On Fri, Aug 24, 2007 at 10:56:08 -0700, Greg KH wrote:
> > On Fri, Aug 24, 2007 at 07:38:40PM +0200, Michal Piotrowski wrote:
> > > Hi all,
> > > 
> > > Here is a list of some known regressions in 2.6.23-rc3.
> > 
> > First off, thanks so much for tracking these, it can't be an easy job,
> > but one that is really needed.  Keep up the great work.
> > 
> > > USB
> > > 
> > > Subject         : 2.6.23-rc1: USB hard disk broken
> > > References      : http://lkml.org/lkml/2007/7/25/62
> > > Last known good : ?
> > > Submitter       : Tino Keitel <tino.keitel@gmx.de>
> > > Caused-By       : ?
> > > Handled-By      : Oliver Neukum <oliver@neukum.org>
> > > Status          : unknown
> > 
> > Last I heard was that Tino was going to try to do further testing, but
> > as he hasn't responded in a few weeks, I'd mark this one down to,
> > "unknown and unreproducable".  Unless someone else knows more?
> 
> I was at least able to reproduce it with 2.6.23-rc2. And I tried it
> hard with 2.6.22 but it didn't happen.

Ick, I didn't realize this.

Oliver and Alan, any follow-up on this that I need to look into?

thanks,

greg k-h
