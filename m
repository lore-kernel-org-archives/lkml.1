Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbXE1VOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbXE1VOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXE1VOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:14:39 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:48250 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762278AbXE1VOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:14:38 -0400
Date: Mon, 28 May 2007 17:14:36 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stuff ready to be deleted?
In-Reply-To: <9a8748490705281324u509d9019qa7e60e446ca509b9@mail.gmail.com>
Message-ID: <alpine.DEB.0.99.0705281712190.10522@sigma.j-a-k-j.com>
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
 <9a8748490705281324u509d9019qa7e60e446ca509b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   i'm trying to keep track of kernel janitor projects that involve
> > removing dead content from the tree:
> > 
> > http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
> > 
> > currently, the list contains the items:
> > 
> >     * 1 Legacy power management
> >     * 2 PCMCIA IOCTL support
> >     * 3 Traffic shaper
> >     * 4 Traffic policing
> >     * 5 Userspace queueing via NETLINK
> >     * 6 ebt: ulog support
> >     * 7 MOXA SmartIO support
> >     * 8 Old I2O ioctls
> >     * 9 Stallion drivers
> >     * 10 SDL RISCom/8 support
> >     * 11 Macintosh M68K support
> >     * 12 Commodore A2232 serial support
> >     * 13 CONFIG_FORCED_INLINING
> >     * 14 kernel_thread()
> > 
> > which of the above are legitimate candidates for removal?  which are
> > already underway in someone's local tree?  anything else that can
> > be added?  etc, etc.
> > 
> 
> Take a look at Documentation/feature-removal-schedule.txt
> Some of that stuff is already listed there along with who is in charge
> of removing it and when.

Let's not get in that catfight again. That file has been demonstrated to 
be half too premature and half completely obsolete. He's asking for which 
things should he start generating and sending patches and expect them to 
not be ignored or angrily shot down. feature-removal-schedule.txt does not 
provide this information, again as has been demonstrated.

Of course, it would be great if it were accurate and -did- provide that 
information.
