Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbYBHWUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbYBHWUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbYBHWUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:20:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYBHWUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:20:39 -0500
Date: Fri, 8 Feb 2008 14:15:48 -0800
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.24.1
Message-ID: <20080208221548.GA6827@kroah.com>
References: <20080208203404.GC4520@kroah.com> <6101e8c40802081300o3a978d9axef5ca3040d6a5839@mail.gmail.com> <47ACD3F4.8040203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACD3F4.8040203@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 05:13:08PM -0500, Chuck Ebbert wrote:
> On 02/08/2008 04:00 PM, Oliver Pinter wrote:
> > 
> > the v2.6.24.y tree is not published or not visible with git-web on
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary
> > address
> > 
> 
> And,
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> 
> is missing 2.6.23.11, .12 and .13.

And probably the .24 stuff too :)

> This one is much easier to use for figuring out what went into each
> -stable release.

I haven't been using that repo, I think Chris has been setting that one
up.  I'll leave updating it to him, as I'm not quite sure how the
branches are supposed to be there...

thanks,

greg k-h
