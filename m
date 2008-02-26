Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbYBZVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbYBZVlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762767AbYBZVlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:41:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39033 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759117AbYBZVlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:41:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: 2.6.25-rc3: Reported regressions from 2.6.24
Date: Tue, 26 Feb 2008 22:39:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>, "Ingo Molnar" <mingo@elte.hu>
References: <200802250241.40832.rjw@sisk.pl> <8f53421d0802252224o5977cbf0uf45df672de64a5f6@mail.gmail.com>
In-Reply-To: <8f53421d0802252224o5977cbf0uf45df672de64a5f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262239.42172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Michael S. Tsirkin wrote:
> 2008/2/25 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message contains a list of some regressions from 2.6.24 reported since
> >  2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> >  of.  If any of them have been fixed already, please let me know.
> 
> If you want that, I think Cc-ing reporters might be a good idea.
> 
> >  If you know of any other unresolved regressions from 2.6.24, please let me know
> >  either and I'll add them to the list.  Also, please let me know if any of the
> >  entries below are invalid.
> 
> Two other issues, both with tested patches which do not seem to be in
> mainline yet:
> 
> http://lkml.org/lkml/2008/2/22/127
> 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping

http://bugzilla.kernel.org/show_bug.cgi?id=10079

> http://lkml.org/lkml/2008/2/25/400
> new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p
> I think this last one is bug 10100

Yes, it is.

Thanks,
Rafael
