Return-Path: <linux-kernel-owner+w=401wt.eu-S935322AbZDHUHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322AbZDHUHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935253AbZDHUGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:06:46 -0400
Received: from kroah.org ([198.145.64.141]:52669 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932510AbZDHUGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:06:44 -0400
Date: Wed, 8 Apr 2009 10:11:35 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
Message-ID: <20090408171135.GA2625@kroah.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com> <1239167872-8179-3-git-send-email-joe@perches.com> <20090408165110.GA32400@kroah.com> <1239210475.32726.44.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239210475.32726.44.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 10:07:55AM -0700, Joe Perches wrote:
> On Wed, 2009-04-08 at 09:51 -0700, Greg KH wrote:
> > On Tue, Apr 07, 2009 at 10:17:44PM -0700, Joe Perches wrote:
> > >  DRIVER CORE, KOBJECTS, AND SYSFS
> > >  P:	Greg Kroah-Hartman
> > >  M:	gregkh@suse.de
> > >  L:	linux-kernel@vger.kernel.org
> > >  T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> > >  S:	Supported
> > > +F:	Documentation/kobject.txt
> > > +F:	drivers/base/core.c
> > 
> > That should be drivers/base*
> 
> OK.  You'll also get changes in drivers/base/power/

That's fine, those usually go through my tree to Linus as it is.

To limit it to only one file in drivers/base/ is incorrect no matter
what, there are other files in there that I work on :)

> Here it is now...

Looks good to me.

thanks,

greg k-h
