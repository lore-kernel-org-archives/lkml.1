Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFKSfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFKSfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYFKSfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:35:40 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:45102 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYFKSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:35:39 -0400
Date: Wed, 11 Jun 2008 20:35:34 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>
cc: Adrian Bunk <bunk@kernel.org>, zippel@linux-m68k.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: m68k: could the Apollo support possibly work?
In-Reply-To: <alpine.LNX.1.10.0806112002520.6449@firda.kolla.no>
Message-ID: <Pine.LNX.4.64.0806112030590.14769@anakin>
References: <20080608190513.GE4048@cs181133002.pp.htv.fi>
 <alpine.LNX.1.10.0806101847490.26475@halbrend.uninett.no>
 <20080610174532.GD11685@cs181133002.pp.htv.fi> <alpine.LNX.1.10.0806112002520.6449@firda.kolla.no>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-168756637-1213209334=:14769"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-168756637-1213209334=:14769
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 11 Jun 2008, Kolbjørn Barmen wrote:
> On Tue, 10 Jun 2008, Adrian Bunk wrote:
> > On Tue, Jun 10, 2008 at 06:48:34PM +0200, Kolbjørn Barmen wrote:
> > > On Sun, 8 Jun 2008, Adrian Bunk wrote:
> > > 
> > > > Does anyone still have this hardware and tried booting it in recent years?
> > > 
> > > I think I might borrow one from some NetBSD people, if I ask really really
> > > nicely :)
> > 
> > AFAIR NetBSD doesn't support the Apollos.
> 
> OK, I was (and still is) somewhat confused about the defintion of "apollo" :)
> 
> What NetBSD does support is the so called hp300, the Apollo DNXXXXX is not
> supported, allthough there appearantly a guy "working" on it every now and
> then.  http://netbsd.pair.com/Ports/hp300/ 
> 
> What definition of Apollo are we talking about in Linux/m68k context?
> I thought it was http://www.tazenda.demon.co.uk/phil/linux-hp/ which
> actuall is hp300, from what I can tell.

We're talking about the real Apollos (DNxxxx): the machines that used to run
DomainOS, and felt very sad when they couldn't find their friends on the
(token ring) network ;-)

`hp300' means HP/Apollo 9000 machines, more specifically the 300 and 400
series.

Later HP/Apollo 9000 machines (e.g. the 700 series) used PA-RISC, not
m68k.

> > Do you plan to work on getting the Linux support back into shape?
> 
> Heh, no, I was just saying that I might try to boot one :)

"If it compiles, it is good, if it boots up it is perfect."
                                        -- Linus Torvalds.

(for the Apollo, I can only keep it `good' ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-168756637-1213209334=:14769--
