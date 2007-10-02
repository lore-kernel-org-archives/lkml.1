Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbXJBWpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbXJBWpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbXJBWpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:45:10 -0400
Received: from 1wt.eu ([62.212.114.60]:2776 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbXJBWpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:45:09 -0400
Date: Wed, 3 Oct 2007 00:44:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002224459.GO10199@1wt.eu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 08:41:49PM -0700, Linus Torvalds wrote:
> 
> I said I was hoping that -rc8 was the last -rc, and I hate doing this, but 
> we've had more changes since -rc8 than we had in -rc8. And while most of 
> them are pretty trivial, I really couldn't face doing a 2.6.23 release and 
> take the risk of some really stupid brown-paper-bag thing.
> 
> So there's a final -rc out there, and right now my plan is to make this 
> series really short, and release 2.6.23 in a few days. So please do give 
> it a last good testing, and holler about any issues you find!

Looks pretty good at first glance. Dual-K7, adaptec 29160, NFS, e1000,
root on /dev/sda*. Not even one bad thing to report yet.

Cheers,
Willy

