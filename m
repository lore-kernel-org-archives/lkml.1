Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbZLOOgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbZLOOgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbZLOOgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:36:23 -0500
Received: from kroah.org ([198.145.64.141]:59824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbZLOOgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:36:22 -0500
Date: Tue, 15 Dec 2009 06:31:48 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russ Dill <russ.dill@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
Message-ID: <20091215143148.GB12292@kroah.com>
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com>
 <1260849652.28808.1.camel@russ-laptop>
 <alpine.LFD.2.00.0912142027440.14385@localhost.localdomain>
 <alpine.LFD.2.00.0912142043180.14385@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912142043180.14385@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 08:44:33PM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 14 Dec 2009, Linus Torvalds wrote:
> > 
> > Ok, this looks sane. I'll test it on the machine that had trouble.
> 
> Tests fine. I'd still like the trivial cleanup, but at least this confirms 
> that the problem was that the original patch matches the wrong device due 
> to not matching on the driver field.
> 
> Greg, do you want me to do this (revert+fixed patch), or are you going to 
> send me a pull request with it all sorted out?

I will provide a tree with a revert and addition of the new patch in a
few hours.

thanks,

greg k-h
