Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbXHQEzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbXHQEzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbXHQEz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:55:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3506 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbXHQEz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:55:26 -0400
Subject: Re: [PATCH] [120/2many] MAINTAINERS - CFAG12864BFB LCD FRAMEBUFFER
	DRIVER
From: Joe Perches <joe@perches.com>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <653402b90708162137r6079d431ud91216bb7b140610@mail.gmail.com>
References: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
	 <653402b90708160216k1ea20490k7a846bd019e44b3d@mail.gmail.com>
	 <1187272507.5906.80.camel@localhost>
	 <653402b90708162137r6079d431ud91216bb7b140610@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 21:55:15 -0700
Message-Id: <1187326515.822.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 06:37 +0200, Miguel Ojeda wrote:
> On 8/16/07, Joe Perches <joe@perches.com> wrote:
> > On Thu, 2007-08-16 at 11:16 +0200, Miguel Ojeda wrote:
> > > I think you could add also:
> > >  +F:     Documentation/auxdisplay/cfag12864bfb
> does not exist. I meant
>    Documentation/auxdisplay/cfag12864b
> As Documentation/auxdisplay/cfag12864b describes both at the same
> time, it is OK to add them in both entries.
> Sorry for the mistake.

No worries.  We all make a bunch of 'em.

This is what I have now:

CFAG12864B LCD DRIVER
P:	Miguel Ojeda Sandonis
M:	maxextreme@gmail.com
L:	linux-kernel@vger.kernel.org
W:	http://auxdisplay.googlepages.com/
S:	Maintained
F:	Documentation/auxdisplay/cfag12864b
F:	drivers/auxdisplay/cfag12864b.c
F:	include/linux/cfag12864b.h

CFAG12864BFB LCD FRAMEBUFFER DRIVER
P:	Miguel Ojeda Sandonis
M:	maxextreme@gmail.com
L:	linux-kernel@vger.kernel.org
W:	http://auxdisplay.googlepages.com/
S:	Maintained
F:	Documentation/auxdisplay/cfag12864b
F:	drivers/auxdisplay/cfag12864bfb.c
F:	include/linux/cfag12864b.h

cheers, Joe

