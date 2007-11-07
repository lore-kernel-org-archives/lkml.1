Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXKGXuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXKGXuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXKGXuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:50:10 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:41444 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXKGXuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:50:08 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>
Cc: James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Date: Thu, 8 Nov 2007 01:49:50 +0200
Message-Id: <20071107234211.M52324@visp.net.lb>
In-Reply-To: <20071107232045.GA26706@havoc.gtf.org>
References: <20071101213013.M54162@visp.net.lb> <20071106221521.4f64a066.akpm@linux-foundation.org> <20071107132630.M65286@visp.net.lb> <4731D85E.70201@daa.com.au> <20071107160426.M31617@visp.net.lb> <47320E37.8010106@rtr.ca> <20071107232045.GA26706@havoc.gtf.org>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am using Gentoo (and it is custom build of linux, actually only busybox + 
kernel + uclibc and few other tools), hdparm is vanilla 7.7

I will try to compile now -rc2 to see if there any changes.

With 16MB 2.6.24-rc1 works fine, 1GB working also with some errors in dmesg. 

And IF that all is important, cause it is relatively old hardware and 
probably if it is only this hardware-specific bug, it is enough to issue 
workaround just to be able to use it. I dont think so someone using them now 
much, but IMHO things must work in kernel if they are there.

On Wed, 7 Nov 2007 18:20:45 -0500, Jeff Garzik wrote
> On Wed, Nov 07, 2007 at 02:12:55PM -0500, Mark Lord wrote:
> > That cannot be correct (??).  Is this with hdparm-7.7 (latest 
sourceforge) 
> > ??
> > Can you show us the "hdparm --Istdout" output as well, please.
> 
> If this is applicable...  FWIW hdparm was only recently (in past <72
> hours) updated from 6.9 to 7.7 in Fedora...
> 
> 	Jeff


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

