Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZL3JDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZL3JDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZL3JDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:03:02 -0500
Received: from vps2.mechanicalrealm.com ([66.216.20.21]:51659 "EHLO
	zinan.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZL3JDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:03:00 -0500
From: "Luke-Jr" <luke@dashjr.org>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
Date: Wed, 30 Dec 2009 03:02:23 -0600
User-Agent: KMail/1.12.3 (Linux/2.6.32-gentoo; KDE/4.3.3; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe \(Nokia-D\/Helsinki\)" <felipe.balbi@nokia.com>
References: <200912290152.16357.luke@dashjr.org> <200912292110.42122.luke@dashjr.org> <87pr5xvslk.fsf@purkki.valot.fi>
In-Reply-To: <87pr5xvslk.fsf@purkki.valot.fi>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912300302.29725.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009 01:17:11 am Kalle Valo wrote:
> "Luke-Jr" <luke@dashjr.org> writes:
> > On that topic, is there a reason the newer code is under a unified "N8x0"
> > config option instead of the split N800/N810 that was used for the old
> > code, or is that simply a symptom of the currently-supported features all
> > being common?
> 
> IIRC, I just used one common n8x0 file because the n810 board file was
> very small and I didn't see any benefit from having it separately.

Yeah, that's because someone put all the N810 code in the N800 file ;)

Will probably at least split out the differences, if there's no other reason, 
then. Since I'm doing this stuff only for my own personal interest, I'll 
probably not bother to do much with N800 support unless someone feels like 
sending me one when I finish N810 (definitely not touching N800 before then).

Luke
