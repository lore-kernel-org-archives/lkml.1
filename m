Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbZJOV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbZJOV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758327AbZJOV63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:58:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:38832 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbZJOV63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:58:29 -0400
Date: Thu, 15 Oct 2009 14:54:59 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: alan@linux.intel.com, stable@kernel.org, stable-commits@vger.kernel.org,
       fredlwm@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: patch pty-quickfix-for-the-pty-enxio-timing-problems.patch
 added to 2.6.31-stable tree
Message-ID: <20091015215459.GA11142@suse.de>
References: <20091015184454.5BEDB48B35@coco.kroah.org>
 <alpine.LFD.2.01.0910151450420.6146@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910151450420.6146@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 02:52:01PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 15 Oct 2009, gregkh@suse.de wrote:
> > 
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: pty: quickfix for the pty ENXIO timing problems
> 
> No. This is incorrect. It got reverted in mainline (commit e043e42bdb6).

Hm, ok, Marcin asked that I include this patch as it fixed his keyboard
problems with X on 2.6.31.

Marcin, any ideas?

I'll go drop this from the .31-stable queue.

thanks,

greg k-h
