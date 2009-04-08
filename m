Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbZDHSFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbZDHSFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbZDHSFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:05:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616AbZDHSFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:05:18 -0400
Date: Wed, 8 Apr 2009 11:02:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: MAX3100
In-Reply-To: <20090408175455.GA6721@localhost.pp.htv.fi>
Message-ID: <alpine.LFD.2.00.0904081101290.4583@localhost.localdomain>
References: <20090408114427.28788.50640.stgit@t61.ukuu.org.uk> <20090408175455.GA6721@localhost.pp.htv.fi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Apr 2009, Adrian Bunk wrote:

> On Wed, Apr 08, 2009 at 12:44:52PM +0100, Alan Cox wrote:
> > Thou shalt remember to use 'git add' or there will errors and wrath from on
> > list and much wailing and gnashing of teeth.
> > 
> > Signed-off-by: Alan "I'm hiding" Cox <alan@lxorguk.ukuu.org.uk>
> > ---
> > 
> >  drivers/serial/max3100.c |  927 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 927 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/serial/max3100.c
> >...
> > --- /dev/null
> > +++ b/drivers/serial/max3100.c
> >...
> > +#include <linux/serial_max3100.h>
> >...
> 
> Thou shalt remember to also send the header file.

LOL.

Alan, try "git status". I wonder how many other files you have hiding in 
there..

			Linus
