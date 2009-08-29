Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZH2MaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZH2MaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 08:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZH2MaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 08:30:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZH2MaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 08:30:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #13646] warn_on tty_io.c, broken bluetooth
Date: Sat, 29 Aug 2009 14:31:14 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <84144f020908252314l364588bfi16e2d426cece2c5a@mail.gmail.com> <20090829093657.GC1634@ucw.cz>
In-Reply-To: <20090829093657.GC1634@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908291431.14313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 August 2009, Pavel Machek wrote:
> On Wed 2009-08-26 09:14:02, Pekka Enberg wrote:
> > On Wed, Aug 26, 2009 at 12:05 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.29 and 2.6.30.
> > >
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.29 and 2.6.30. ?Please verify if it still should
> > > be listed and let me know (either way).
> > >
> > >
> > > Bug-Entry ? ? ? : http://bugzilla.kernel.org/show_bug.cgi?id=13646
> > > Subject ? ? ? ? : warn_on tty_io.c, broken bluetooth
> > > Submitter ? ? ? : Pavel Machek <pavel@ucw.cz>
> > > Date ? ? ? ? ? ?: 2009-06-19 17:05 (68 days old)
> > > References ? ? ?: http://lkml.org/lkml/2009/6/19/187
> > 
> > Pavel, is this still an open issue? Plenty tty fixes went into 2.6.31
> > so maybe we need to backport some of them to -stable?
> 
> It seems to be interminent, and depends on timing/usage patterns. (Try
> to start bluetooth when it is already starting). It
> is possible that it was there before. Perhaps it can be just closed as
> 'bug but not regression'.

Done.

Thanks,
Rafael
