Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYBHVKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYBHVKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYBHVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:09:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:57957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYBHVJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:09:53 -0500
Date: Fri, 8 Feb 2008 13:07:56 -0800
From: Greg KH <gregkh@suse.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.24.1
Message-ID: <20080208210756.GA5429@suse.de>
References: <20080208203404.GC4520@kroah.com> <6101e8c40802081300o3a978d9axef5ca3040d6a5839@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802081300o3a978d9axef5ca3040d6a5839@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 10:00:56PM +0100, Oliver Pinter wrote:
> Hi!
> 
> the v2.6.24.y tree is not published or not visible with git-web on
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary
> address

Hm, that was odd, Chris created that tree in a different way than
normal, which worked to push and pull from directly through ssh, but
didn't work through the gitweb interface.

It should be fixed now, but might take 30 minutes or so to propagate.

If within an hour, it's still not working, please let me know.

thanks,

greg k-h
