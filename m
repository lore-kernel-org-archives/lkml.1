Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXBMJsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXBMJsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965487AbXBMJsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:48:40 -0500
Received: from iona.labri.fr ([147.210.8.143]:37758 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965483AbXBMJsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:48:39 -0500
Date: Tue, 13 Feb 2007 10:48:37 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Sascha Sommer <saschasommer@freenet.de>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, rmk+mmc@arm.linux.org.uk,
       Elladan <elladan@eskimo.com>
Subject: Re: Experimental driver for Ricoh Bay1Controller SD Card readers
Message-ID: <20070213094837.GA3646@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Sascha Sommer <saschasommer@freenet.de>,
	Jiri Slaby <jirislaby@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, rmk+mmc@arm.linux.org.uk,
	Elladan <elladan@eskimo.com>
References: <200701070032.27234.saschasommer@freenet.de> <45A0C3A7.2040506@gmail.com> <200702112122.38440.saschasommer@freenet.de> <45D150FD.8080901@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45D150FD.8080901@drzeus.cx>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman, le Tue 13 Feb 2007 06:47:41 +0100, a écrit :
> Sascha Sommer wrote:
> > I still consider this driver experimental, but without documentation this is 
> > probably not going to change anytime soon.
> > The question is now what I should do with the driver?
> > Is it worth to be included in the kernel? If yes where and against what 
> > kernelversion should I send the patch?
> 
> That's up to you. The most important thing for any part of the kernel is
> that it must have a maintainer. So if you are ready to keep the driver
> up to date and handle the support requests that show, then you should
> really submit it.

You can mark your Kconfig entry with EXPERIMENTAL for letting people
know about the status :)

Samuel
