Return-Path: <linux-kernel-owner+w=401wt.eu-S934109AbXJLXKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109AbXJLXKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933348AbXJLW3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:29:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:54271 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933345AbXJLW3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:29:47 -0400
Date: Fri, 12 Oct 2007 15:28:06 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.23
Message-ID: <20071012222806.GA5365@suse.de>
References: <20071012221245.GA4559@kroah.com> <20071012.152050.71091255.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012.152050.71091255.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 03:20:50PM -0700, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Fri, 12 Oct 2007 15:12:45 -0700
> 
> > Alan Stern (44):
>  ...
> >       USB: mutual exclusion for EHCI init and port resets
> 
> Greg, if you haven't already, please consider queueing
> this one up for -stable too.

Ah, good idea, I'll go do that.

thanks,

greg k-h
