Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbXBMLl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbXBMLl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXBMLl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:41:57 -0500
Received: from mout2.freenet.de ([194.97.50.155]:59816 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXBMLl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:41:56 -0500
From: Sascha Sommer <saschasommer@freenet.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Experimental driver for Ricoh Bay1Controller SD Card readers
Date: Tue, 13 Feb 2007 12:42:12 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rmk+mmc@arm.linux.org.uk, Elladan <elladan@eskimo.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>
References: <200701070032.27234.saschasommer@freenet.de> <200702112122.38440.saschasommer@freenet.de> <45D150FD.8080901@drzeus.cx>
In-Reply-To: <45D150FD.8080901@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131242.12507.saschasommer@freenet.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 13 February 2007 06:47, Pierre Ossman wrote:
> Sascha Sommer wrote:
> > I still consider this driver experimental, but without documentation this
> > is probably not going to change anytime soon.
> > The question is now what I should do with the driver?
> > Is it worth to be included in the kernel? If yes where and against what
> > kernelversion should I send the patch?
>
> That's up to you. The most important thing for any part of the kernel is
> that it must have a maintainer. So if you are ready to keep the driver
> up to date and handle the support requests that show, then you should
> really submit it.
>
> Patches should always be sent against the current version of the kernel
> (i.e. git HEAD). Usually the latest packaged release will also do.
>
> (Note that I haven't had time to review your latest version of the driver)
>

Yes, I'm going to maintain it. There are still some bugs that need to be fixed 
first, though. I also got a mail from someone else how also did some 
reverseengineering work for this reader. I'm waiting for his feedback before 
I will submit a patch that can be included.

Thanks.

Sascha

