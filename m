Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXEQU1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXEQU1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762016AbXEQU0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:26:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3031 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761693AbXEQU0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:26:44 -0400
Date: Thu, 17 May 2007 20:18:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dongjun Shin <djshin90@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070517201847.GA5032@ucw.cz>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <1179317240.2859.222.camel@shinybook.infradead.org> <20070516083408.dcd9dd78.akpm@linux-foundation.org> <1179330596.2859.248.camel@shinybook.infradead.org> <20070516164158.GB8113@lazybastard.org> <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com> <1179383117.2859.416.camel@shinybook.infradead.org> <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Yes. These things are almost always implemented _very_ 
> >badly by the same
> >kind of crack-smoking hobo they drag in off the streets 
> >to write BIOSen.
> >
> >It's bog-roll technology; if you fancy a laugh try 
> >doing some real
> >reliability tests on them time some. Powerfail testing 
> >is a good one.
> >
> >This kind of thing is OK for disposable storage such as 
> >in digital
> >cameras, where it doesn't matter that it's no more 
> >reliable than a
> >floppy disc, but for real long-term storage it's really 
> >a bad idea.
> >
> 
> There are so many flash-based storage and some 
> disposable storages,
> as you pointed out, have poor quality. I think it's 
> mainly because these
> are not designed for good quality, but for lowering the 
> price.
> 
> These kind of devices are not ready for things like 
> power failure because
> their use case is far from that. For example, removing 
> flash card
> while taking pictures using digital camera is not a 
> common use case.
> (there should be a written notice that this kind of 
> action is against
> the warranty)

Hmm.. so operating your camera on batteries should be against the
warranty, since batteries commonly run empty while storing pictures?


							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
