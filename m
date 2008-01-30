Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYA3Hi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYA3Hi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYA3Hiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:38:50 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:45416 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYA3Hiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:38:50 -0500
Date: Wed, 30 Jan 2008 08:38:47 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: ndiswrapper and GPL-only symbols redux
In-Reply-To: <yw1x4pcw3zu9.fsf@mansr.com>
Message-ID: <Pine.LNX.4.64.0801300836030.12371@anakin>
References: <1201641765.18773.35.camel@dv> <20080129225701.GS8767@does.not.exist>
 <yw1x8x2843kt.fsf@mansr.com> <20080130003519.GB1802@does.not.exist>
 <yw1x4pcw3zu9.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-517969928-1201678727=:12371"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-517969928-1201678727=:12371
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 Jan 2008, Måns Rullgård wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> > On Tue, Jan 29, 2008 at 11:25:22PM +0000, Måns Rullgård wrote:
> >> As long as you don't distribute /proc/kcore, I can't see how the GPL
> >> would have any say in the matter.  The Windows drivers are (unrelated
> >> violations aside) clearly not derived from GPL code.
> >
> > Someone might sell a laptop with Linux installed?
> 
> Not a problem, unless it is booted when sold.  Even that might not be
> a problem, since it would be a matter of transferring ownership of a
> single copy, not creating and distributing new copies, and the GPL
> does is only concerned with the latter.

Interesting... I never heard about this `transferring ownership of a
single copy not involving GPL'.

Note that some lawyers claim that at trade shows, you should not hand over
a demo device running GPLed code to any interested party, as it would be
distribution...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-517969928-1201678727=:12371--
