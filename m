Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbXHSAdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbXHSAdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 20:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXHSAdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 20:33:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1059 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbXHSAdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 20:33:03 -0400
Subject: Re: tracking MAINTAINERS versus tracking SUBSYSTEMS
From: Joe Perches <joe@perches.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>
References: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 17:32:58 -0700
Message-Id: <1187483578.4200.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-18 at 13:35 -0400, Robert P. J. Day wrote:
>   $ show_subsystem drivers/bluetooth/bpa10x.c
>   BLUETOOTH

"what's a subsystem"?
I'm not sure there is an appropriate definition.
If there is an appropriate definition, why
should anyone care what subsystem a particular
file is in?

> 1) it reduces the MAINTAINERS file back to what it should be in the
> first place -- a simple reference list of each kernel subsystem, and
> who's responsible for it, so that constant reshuffling of files or
> directories in a particular subsystem doesn't require constant
> updating of the MAINTAINERS file.

I'd still be happy if MAINTAINERS went away.
I'm not sure what good it does other than have
a link to mailing lists that otherwise might not
be CC'd on patches.

> thoughts?

For user submission of bug reports, perhaps it'd be
more useful to have a submitkernelbugreport script
and a network enabled "dispatch bug report" to
appropriate maintainers service.

Try something out and see what happens.

Good luck.  Joe


