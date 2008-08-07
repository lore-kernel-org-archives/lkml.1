Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYHGUwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYHGUwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYHGUwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:52:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:53111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYHGUwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:52:38 -0400
Date: Thu, 7 Aug 2008 13:46:37 -0700
From: Greg KH <gregkh@suse.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.26.2
Message-ID: <20080807204637.GA13216@suse.de>
References: <20080806175529.GB27119@kroah.com> <20080808.002749.25478519.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808.002749.25478519.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:27:49AM +0900, Atsushi Nemoto wrote:
> On Wed, 6 Aug 2008 10:55:29 -0700, Greg KH <gregkh@suse.de> wrote:
> > The updated 2.6.26.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary
> 
> I cannot clone the tree via http protocol.
> 
> $ git-clone --reference linux-2.6 http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
> Initialized empty Git repository in /home/git/linux-2.6.26.y/.git/
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?
> 
> I can clone 2.6.25.y tree vit http.

Bah, sorry, my fault, it should be fixed now, and I've enabled the hook
to run this for any future pushes.

thanks,

greg k-h
