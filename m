Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbXHXR5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbXHXR5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764089AbXHXR5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:57:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763990AbXHXR5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:57:33 -0400
Date: Fri, 24 Aug 2007 10:56:08 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       Zachary Amsden <zach@vmware.com>, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Oliver Falk <oliver@linux-kernel.at>
Subject: Re: [4/4] 2.6.23-rc3: known regressions v3
Message-ID: <20070824175608.GA5333@suse.de>
References: <46CF0DEF.5040107@googlemail.com> <46CF17A0.2060503@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CF17A0.2060503@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 07:38:40PM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc3.

First off, thanks so much for tracking these, it can't be an easy job,
but one that is really needed.  Keep up the great work.

> USB
> 
> Subject         : 2.6.23-rc1: USB hard disk broken
> References      : http://lkml.org/lkml/2007/7/25/62
> Last known good : ?
> Submitter       : Tino Keitel <tino.keitel@gmx.de>
> Caused-By       : ?
> Handled-By      : Oliver Neukum <oliver@neukum.org>
> Status          : unknown

Last I heard was that Tino was going to try to do further testing, but
as he hasn't responded in a few weeks, I'd mark this one down to,
"unknown and unreproducable".  Unless someone else knows more?

thanks,

greg k-h
