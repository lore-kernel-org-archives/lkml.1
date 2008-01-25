Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYAYU3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYAYU3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYAYU3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:29:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:57729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbYAYU3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:29:45 -0500
Date: Fri, 25 Jan 2008 12:28:03 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080125202803.GA14416@suse.de>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125194219.GA4596@suse.de> <alpine.LFD.1.00.0801251221210.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801251221210.2979@hp.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 12:23:25PM -0800, Linus Torvalds wrote:
> On Fri, 25 Jan 2008, Greg KH wrote:
> > Linus, does the patch below (built tested only) fix the above call trace
> > noise for you?  It shouldn't change the taint flag, that's a different
> > issue it seems.
> 
> Sadly, I'm now in the process of shutting down all my machines to prepare 
> for "the flight from hell(tm)", so I won't have time to check this right 
> now.

Ok, I'll queue it up myself in my trees and send it to you in a few
days.

Have a nice trip,

greg k-h
