Return-Path: <linux-kernel-owner+w=401wt.eu-S1030864AbXDMWgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030864AbXDMWgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030865AbXDMWgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:36:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:40297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030864AbXDMWgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:36:11 -0400
Date: Fri, 13 Apr 2007 15:33:51 -0700
From: Greg KH <gregkh@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.7
Message-ID: <20070413223351.GA9738@suse.de>
References: <20070413205659.GA5935@kroah.com> <461FFC19.1020208@redhat.com> <20070413220302.GB7366@suse.de> <462002A9.9060008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462002A9.9060008@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 06:22:33PM -0400, Chuck Ebbert wrote:
> Greg KH wrote:
> >>>
> >>> The updated 2.6.20.y git tree can be found at:
> >>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
> >>> and can be browsed at the normal kernel.org git web browser:
> >>>         www.kernel.org/git/
> >> How long should that take to show up on kernel.org?
> > 
> > I see it there already, must be a slow mirror...
> 
> $ wget http://www1.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
> --18:21:45--  http://www1.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
> Resolving www1.kernel.org... 204.152.191.5
> Connecting to www1.kernel.org|204.152.191.5|:80... connected.
> HTTP request sent, awaiting response... 404 Not Found
> 18:21:46 ERROR 404: Not Found.
> 
> $ wget http://www2.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
> --18:21:51--  http://www2.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.7.bz2
> Resolving www2.kernel.org... 204.152.191.37
> Connecting to www2.kernel.org|204.152.191.37|:80... connected.
> HTTP request sent, awaiting response... 404 Not Found
> 18:21:52 ERROR 404: Not Found.

It's on the master.kernel.org server, and I was just told that the
mirroring script is running about every 7 hours or so, so it will be a
while before it shows up on the public side.

Or you can use the git tree, those seem to be public now :)

thanks,

greg k-h
