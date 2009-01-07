Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbZAGAhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbZAGAhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZAGAhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:37:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:54845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZAGAha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:37:30 -0500
Date: Tue, 6 Jan 2009 16:36:25 -0800
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches for your 2.6-git tree
Message-ID: <20090107003625.GA2838@suse.de>
References: <20090106221123.GA32689@kroah.com> <20090106232330.GE3057@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106232330.GE3057@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 12:23:30AM +0100, Hans J. Koch wrote:
> On Tue, Jan 06, 2009 at 02:11:23PM -0800, Greg KH wrote:
> 
> > Hans J. Koch (2):
> >       UIO: Pass information about ioports to userspace (V2)
> >       UIO: Documentation for UIO ioport info handling
> 
> There were two more patches (more doc updates, name attribute for mappings).
> I just resent them, it'd really be nice if they could get in during this
> merge window as well.

As you sent them to me on December 24 and 25, it's a bit hard to get
some good testing in -next for them (especially as I was on vacation for
2 weeks...)  One of them is just documentation, that will be easy to
send in after -rc1 is out.  The other I need to review, as it adds
additional functionality.

Moral of the story?  Send patches to me earlier :)

thanks,

greg k-h
