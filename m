Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXAaXJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXAaXJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXAaXJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:09:53 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54047 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbXAaXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:09:52 -0500
Date: Wed, 31 Jan 2007 15:04:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>, Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-Id: <20070131150451.070fa90f.randy.dunlap@oracle.com>
In-Reply-To: <20070131230014.GD20514@thunk.org>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
	<20070131201258.GB15128@kroah.com>
	<20070131230014.GD20514@thunk.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 18:00:15 -0500 Theodore Tso wrote:

> On Wed, Jan 31, 2007 at 12:12:58PM -0800, Greg KH wrote:
> > 
> > This kind of offer has _always_ been there for out-of-tree GPL drivers.
> > I have contacted many different groups and driver authors over the years
> > to offer my help in trying to get their code into the mainline kernel.
> > 
> > Some take me up on the offer, others ignore it, and still others activly
> > refuse to do so, saying they want to stay out-of-the tree (lirc is one
> > of these examples...)
> 
> I think the point is that if we are offering free development effort
> to write a driver which goes into mainline, maybe we should provide
> more than "providing rules and guidelines" so that people can spend
> engineering $$$ to get the driver into mainline.   
> 
> More specifically, Dave said that it "seemed rude" to just take the
> driver and send updates, but maybe the best way of dealing with
> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
> kind of spec release, and just have someone in the community forcibly
> take the code, fix it up, and then get it merged.  Maybe it's being
> "rude", but so is not responding to requests to get it merged.


and I'm quite willing to apply Doc/CodingStyle to driver source file(s).
That's as easy as replying to an email with comments about it.

---
~Randy
