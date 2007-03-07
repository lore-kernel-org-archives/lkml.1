Return-Path: <linux-kernel-owner+w=401wt.eu-S965526AbXCGOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbXCGOY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXCGOY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:24:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965526AbXCGOY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:24:26 -0500
Date: Wed, 7 Mar 2007 06:22:33 -0800
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux v2.6.21-rc3
Message-ID: <20070307142233.GA9204@kroah.com>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <1173263132.9349.47.camel@localhost.localdomain> <20070307132621.GA8084@kroah.com> <45EEC90B.6030407@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EEC90B.6030407@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:15:39AM -0500, Mark Lord wrote:
> Greg / Adrian,
> 
> I didn't see anything in -rc3 to address the USB hub/serial crashes
> reported here for -rc2.  What's the status for those, or who should
> I be pinging to get them fixed?

I have a series of USB bugfixes that need to get sent to Linus that
should fix the serial issues.  I'll get to them after I drag this next
-stable release out the door...

thanks,

greg k-h
