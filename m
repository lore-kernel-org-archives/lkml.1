Return-Path: <linux-kernel-owner+w=401wt.eu-S933715AbXHYIwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbXHYIwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 04:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765358AbXHYIwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 04:52:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765066AbXHYIwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 04:52:06 -0400
Date: Sat, 25 Aug 2007 10:51:46 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Greg KH <greg@kroah.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Matt Colyer <matt@colyer.name>,
       jeffm@suse.de
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
In-Reply-To: <20070824183349.GA14855@kroah.com>
Message-ID: <Pine.LNX.4.58.0708251043090.2006@be1.lrz>
References: <8VtFd-7mx-51@gated-at.bofh.it> <E1IOWl6-0000iK-5t@be1.lrz>
 <20070824183349.GA14855@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19BZWHZcCDU/U89yWk8KWid2KjORDAZOWxfZGw
 lc/y+MCOn/t0I2vbCUERELxK5vdBYhnQefzc6rxrDmyP1+fIUd
 igchlDECuwJREpX+6ZDcA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Greg KH wrote:
> On Fri, Aug 24, 2007 at 12:51:19PM +0200, Bodo Eggert wrote:
> > Greg KH <greg@kroah.com> wrote:

> > > my berry_charge code that adds support for charging the iphone when it
> > > is plugged into a Linux machine.
> > 
> > This should be a runtime option, because you may want to build a non-module
> > kernel and not charge the phone while running your laptop on battery.
> 
> Then just don't build this module if you are creating such a kernel :)
> 
> Same thing goes for the existing blackberry charge driver too...

So I have to reboot if I want to charge my (blackberry|iphone) on my 
laptop?

Even if you say installing 850 KB of software (modutils) in order to 
toggle charging an iphone is sane, having to (un)load a module is not
user-friendly.

-- 
"'Multiple exclamation marks,' he went on, shaking his head, 'are a 
sure sign of a diseased mind.'"
	-- Terry Pratchett in "Eric"
