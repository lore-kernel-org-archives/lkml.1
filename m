Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbXLPLPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbXLPLPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762270AbXLPLPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:15:35 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:42564 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760524AbXLPLPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:15:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore =?iso-8859-1?q?to=09mutex?=
Date: Sun, 16 Dec 2007 12:13:15 +0100
User-Agent: KMail/1.9.6
Cc: bcm43xx-dev@lists.berlios.de, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, Ray Lee <ray-lk@madrabbit.org>,
       Simon Holm =?iso-8859-1?q?Th=F8gersen?= <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Ingo Molnar <mingo@elte.hu>,
       kjwinchester@gmail.com, linux@bohmer.net
References: <20071213003028.676998182@mvista.com> <200712160027.19950.mb@bu3sch.de> <47648DB8.1080205@lwfinger.net>
In-Reply-To: <47648DB8.1080205@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712161213.15701.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 December 2007 03:30:16 Larry Finger wrote:
> Michael Buesch wrote:
> > On Sunday 16 December 2007 00:18:43 Rafael J. Wysocki wrote:
> >> Well, the only problem with that is I suspect there are some "newer" cards that
> >> work better with v3 firmware, although they are supposed to support both.
> > 
> > And I suspect that you are wrong until you show me one. :)
> 
> The BCM4311/1 card used to work better with bcm43xx than it did with b43; however, since the power 
> control problem was "solved" in b43, there is very little difference. When I built my special system 
> to use the BCM4311 with b43legacy, there was no difference.
> 
> I don't know of any cards that work better with bcm43xx than with b43. Of course, that is comparing 
> SoftMAC with mac80211. There is, of course, no comparison.

This was about version 3 firmware vs version 4 firmware.
I doubt the firmware makes any difference at all.

-- 
Greetings Michael.
