Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622Ab0APV4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0APV4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 16:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346Ab0APV4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 16:56:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0APV4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 16:56:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: m.s.tsirkin@gmail.com
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
Date: Sat, 16 Jan 2010 22:57:16 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.ker>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <20100116174821.GA18306@redhat.com>
In-Reply-To: <20100116174821.GA18306@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001162257.16277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 January 2010, m.s.tsirkin@gmail.com wrote:
> On Tue, Dec 29, 2009 at 04:05:30PM +0100, Rafael J. Wysocki wrote:
> > [NOTES:
> >  * There you go, another round of tracking regressions.  It's not too bad at
> >    the moment, as far as the regressions from 2.6.32 are concerned, but we have
> >    quite a few -stable regressions, apparently in the DRI area.
> 
> I have another one there :)
> 
> Immediately upon startup, screen is flickering (becomes
> lighter and darker again). The problem occurs with kernels
> 2.6.33-rc1 to 2.6.33-rc4, but not with kernel 2.6.32 and below.

We've already had several reports like this already.

Care to review the bugs linked to http://bugzilla.kernel.org/show_bug.cgi?id=14885
and check if none of them matches the problem you describe?

Rafael
