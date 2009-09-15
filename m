Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZIOVem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZIOVem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZIOVeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:34:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZIOVeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:34:36 -0400
Date: Tue, 15 Sep 2009 14:32:35 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of
 searching  the array
Message-ID: <20090915213235.GA6968@suse.de>
References: <20090915181247.GA32167@kroah.com>
 <1253041976-1111-6-git-send-email-gregkh@suse.de>
 <1253043763.11643.358.camel@desktop>
 <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
 <1253045229.11643.398.camel@desktop>
 <20090915202445.GC3411@suse.de>
 <1253049491.11643.490.camel@desktop>
 <20090915212019.GA6744@suse.de>
 <1253050006.11643.492.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253050006.11643.492.camel@desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 02:26:46PM -0700, Daniel Walker wrote:
> On Tue, 2009-09-15 at 14:20 -0700, Greg KH wrote:
> 
> > I'll gladly do that, it's trival for me to do so.
> > 
> 
> What about the other side ? The people who are sending the clean ups,
> there time is valuable too..

Don't you mean "their"?  (hey, I can be nit-picky too...)

And yes, but the engineering model of the kernel development cycle is
that engineer hours are wasted and thrown away all the time.  They are
surplus, sorry.  That's how life works here.

> I hope you don't ignore these errors very often ..

More often then you want to know, I have real issues to deal with :)

thanks,

greg "it's a _guide_ dammit!" k-h
