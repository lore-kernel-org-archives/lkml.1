Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZGRPZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZGRPZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZGRPZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:25:29 -0400
Received: from kroah.org ([198.145.64.141]:35609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbZGRPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:25:28 -0400
Date: Sat, 18 Jul 2009 08:04:41 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Pavel Machek <pavel@ucw.cz>, swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream for staging
Message-ID: <20090718150441.GA8365@kroah.com>
References: <20090710083709.GA6418@elf.ucw.cz>
 <20090716230042.GB3609@kroah.com>
 <20090717010157.GA2002@elf.ucw.cz>
 <20090717011211.GA16704@kroah.com>
 <20090717120657.GB2192@elf.ucw.cz>
 <20090717134620.GB1315@kroah.com>
 <20090717135743.GB19854@elf.ucw.cz>
 <20090717141440.GA16660@kroah.com>
 <20090718104126.GC11381@elf.ucw.cz>
 <1247925191.14209.707.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247925191.14209.707.camel@desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 06:53:11AM -0700, Daniel Walker wrote:
> On Sat, 2009-07-18 at 12:41 +0200, Pavel Machek wrote:
> 
> > (BTW: I do not see the patches in the git tree, yet, and the tree is
> > labeled as "junk tree, please ignore". Should I just wait a bit? Or is
> > staging maintained outside of git? Or should the description be
> > updated?)
> 
> Staging is a quilt tree .. In Linux-next Next/Trees has it listed as,
> 
> staging         quilt   http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/
> 
> I guess it was once a git tree, but was changed over at some point.

The "junk tree" you see is what I used to send stuff to Linus.

Use the quilt tree above, or linux-next, it has the stuff in it as well.

thanks,

greg k-h
