Return-Path: <linux-kernel-owner+w=401wt.eu-S934711AbZGQOXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711AbZGQOXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934699AbZGQOXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:23:08 -0400
Received: from kroah.org ([198.145.64.141]:41757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934617AbZGQOXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:23:06 -0400
Date: Fri, 17 Jul 2009 07:14:40 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream for staging
Message-ID: <20090717141440.GA16660@kroah.com>
References: <20090710083709.GA6418@elf.ucw.cz>
 <20090716230042.GB3609@kroah.com>
 <20090717010157.GA2002@elf.ucw.cz>
 <20090717011211.GA16704@kroah.com>
 <20090717120657.GB2192@elf.ucw.cz>
 <20090717134620.GB1315@kroah.com>
 <20090717135743.GB19854@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717135743.GB19854@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 03:57:43PM +0200, Pavel Machek wrote:
> On Fri 2009-07-17 06:46:20, Greg KH wrote:
> > On Fri, Jul 17, 2009 at 02:06:57PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > I guess I'm confused. I seem to recall that HTC Dream camera support
> > > was marged into staging, but I can't see it in
> > > http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=summary
> > > . Is my memory wrong am I looking at wrong tree?
> > 
> > I never merged it.
> 
> Ok, I guessed so. I sent it as patch #4, patch #5 adds makefile glue
> for all that. They should be all in your inbox now.

I see 5 patches, but in the future, please number them to ensure that
they are applied in the correct order.

thanks,

greg k-h
