Return-Path: <linux-kernel-owner+w=401wt.eu-S932373AbXBNQlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbXBNQlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbXBNQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:41:08 -0500
Received: from ns2.suse.de ([195.135.220.15]:34897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbXBNQlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:41:07 -0500
Date: Wed, 14 Feb 2007 08:39:48 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, torvalds@linux-foundation.org,
       neilb@suse.de, viro@zeniv.linux.org.uk, hch@lst.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Message-ID: <20070214163948.GA5846@kroah.com>
References: <20070213195116.GA5181@kroah.com> <5a4c581d0702140147s7931bd63ief299780fa6963a5@mail.gmail.com> <200702140157.59252.agruen@suse.de> <5a4c581d0702140313q6d048eufa83d7b3d058311@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4c581d0702140313q6d048eufa83d7b3d058311@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 12:13:52PM +0100, Alessandro Suardi wrote:
> On 2/14/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> >Hi,
> >
> >I've described the problem and possible fixes in the "Re: [PATCH] Fix 
> >d_path
> >for lazy unmounts" thread, Message-Id: 200702140019.36378.agruen@suse.de.
> 
> Yes, I saw that. But there isn't any patch for me to test, and my
> userspace remains broken. Please don't get me wrong - I'm
> not bitching about this, but I will effectively not be able to test
> newer snapshots until either a fix for this new bug gets in, or
> the commit that introduced the bug gets reverted.

The commit was reverted, the latest git tree should work just fine.

thanks,

greg k-h
