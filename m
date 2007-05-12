Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXELQmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXELQmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXELQmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:42:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXELQma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:42:30 -0400
Date: Sat, 12 May 2007 09:35:09 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: David Woodhouse <dwmw2@redhat.com>
Cc: "Maciej W. Rozycki" <macro-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
       Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>,
       kernel-discuss-CN5wO63fgwogsBAKwltoeQ@public.gmane.org,
       Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou-JGs/UdohzUI@public.gmane.org>,
       Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
       Satyam Sharma 
	<satyam.sharma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
       zaitcev@redhat.com
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-Id: <20070512093509.f3d1865f.zaitcev@redhat.com>
In-Reply-To: <1178646751.2824.48.camel@pmac.infradead.org>
References: <20070503213303.GH20067@zarina>
	<20070507140453.GD3868@ucw.cz>
	<1178550653.11851.191.camel@pmac.infradead.org>
	<20070507194949.GB3981@ucw.cz>
	<a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	<Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	<1178646751.2824.48.camel@pmac.infradead.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 18:52:31 +0100, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Tue, 2007-05-08 at 18:45 +0100, Maciej W. Rozycki wrote:

> >  Well, my name has an acute above "o" and a dot above "z", but I do not 
> > have such a high expectation as to have it correctly spelled in comments 
> > and elsewhere within some code before I am able to get it right in 
> > official documents issued in English.  And the universe is not going to 
> > collapse because of the missing accents, so I consider this an issue we 
> > can think of resolving once we have fixed all the bugs that we have.
> 
> It's not an issue which needs resolving. We can spell your name just
> fine; we just need Pavel to quit whining and join us in the 21st
> century.

I hate to agree with Pavel, but the real issue here is you being
intentionally obtuse. Naked patches are not compatible with UTF-8.
To assume that UTF-8 is not converted anywhere is tantamount to the
fallacy of SPF: Everyone on the net must do foo, then nirvana happens.
If the code is being pulled git to git, UTF-8 is fine. Or send your
patches in MIME at the very least.

-- Pete
