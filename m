Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbYAYTXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbYAYTXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYAYTXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:23:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:49373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbYAYTXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:23:43 -0500
Date: Fri, 25 Jan 2008 11:27:55 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080125192755.GA17363@suse.de>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125185213.GA23475@suse.de> <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:11:48AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 25 Jan 2008, Greg KH wrote:
> > 
> > That's really wierd, I don't see that at all here just running with your
> > 2.6.24 + my git tree and lots of USB drivers built into the kernel also
> > (like ehci_hcd).
> 
> But do you use an initrd that tries to load the same driver too?

Ah, now I get it, sorry, I'll go check that error path, not exactly a
normal one :)

thanks,

greg k-h
