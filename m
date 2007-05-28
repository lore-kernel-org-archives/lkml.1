Return-Path: <linux-kernel-owner+w=401wt.eu-S932547AbXE1VYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbXE1VYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXE1VXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:23:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:29341 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXE1VXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IDB4m2IMOVoAkCxJ8LX5vBdPs+xbvRICWkYopa1JWlTW53XQQipQWXfS8DrHWA4f1fswzgU8NsRoW7l0bOCRofWdvpR+mEkWPilrkWok6JU4tjEtjr61JzcJ1/W5b3JgeEre3ccDkEaOxeQvuBHKSwftZ9IgS5ucZzky6BCqceQ=
Message-ID: <9a8748490705281423g6cccdc41n60dc48f25cff7598@mail.gmail.com>
Date: Mon, 28 May 2007 23:23:52 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: stuff ready to be deleted?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.99.0705281712190.10522@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
	 <9a8748490705281324u509d9019qa7e60e446ca509b9@mail.gmail.com>
	 <alpine.DEB.0.99.0705281712190.10522@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/07, John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:
> > >   i'm trying to keep track of kernel janitor projects that involve
> > > removing dead content from the tree:
> > >
> > > http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
> > >
> > > currently, the list contains the items:
> > >
> > >     * 1 Legacy power management
> > >     * 2 PCMCIA IOCTL support
> > >     * 3 Traffic shaper
> > >     * 4 Traffic policing
> > >     * 5 Userspace queueing via NETLINK
> > >     * 6 ebt: ulog support
> > >     * 7 MOXA SmartIO support
> > >     * 8 Old I2O ioctls
> > >     * 9 Stallion drivers
> > >     * 10 SDL RISCom/8 support
> > >     * 11 Macintosh M68K support
> > >     * 12 Commodore A2232 serial support
> > >     * 13 CONFIG_FORCED_INLINING
> > >     * 14 kernel_thread()
> > >
> > > which of the above are legitimate candidates for removal?  which are
> > > already underway in someone's local tree?  anything else that can
> > > be added?  etc, etc.
> > >
> >
> > Take a look at Documentation/feature-removal-schedule.txt
> > Some of that stuff is already listed there along with who is in charge
> > of removing it and when.
>
> Let's not get in that catfight again. That file has been demonstrated to
> be half too premature and half completely obsolete. He's asking for which
> things should he start generating and sending patches and expect them to
> not be ignored or angrily shot down. feature-removal-schedule.txt does not
> provide this information, again as has been demonstrated.
>
> Of course, it would be great if it were accurate and -did- provide that
> information.
>

Well, at least that file does give him a clue as to who to talk to
about removal of some of the items on the list.  It may not be as
up-to-date as it ought to be, but it's still a source of
information/contact info.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
