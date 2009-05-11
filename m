Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbZEKUVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbZEKUVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZEKUVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:21:25 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54223 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526AbZEKUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:21:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
Date: Mon, 11 May 2009 22:21:22 +0200
User-Agent: KMail/1.9.9
Cc: johannes@sipsolutions.net, parag.lkml@gmail.com, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, niel.lambrechts@gmail.com
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com> <1241165805.13562.2.camel@johannes.local> <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com> <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain> <1242066170.3873.43.camel@johannes.local> <alpine.LFD.2.01.0905111126320.3586@localhost.localdomain> <1242067939.3873.45.camel@johannes.local> <1242067939.3873.45.camel@johannes.local> <alpine.LFD.2.01.0905111157561.3586@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0905111157561.3586@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905112221.24522.elendil@planet.nl>
X-OriginalArrivalTime: 11 May 2009 20:21:24.0983 (UTC) FILETIME=[0E9BB870:01C9D276]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Well, since I'm testing this laptop for any corner cases, the
> non-working case had actually been tested with things like multiple
> suspend-to-ram cycles (while doing accelerated 3D and sound at the same
> time), along with testing anything else I could think of. And everything
> worked, but wireless wouldn't associate.

JFYI.

I also have a 2510p that I actually _do_ use - as my main workstation - 
both docked (mostly with wired net) and undocked with wireless, and 
between 1 and 4 suspend/resume (to RAM) cycles per day (frequently 
(un)docking while suspended).

I've been running 2.6.30-rc3 and later on it and have not seen any 
wireless (or other) problems. Distro is Debian Lenny.

Firmware in use is:
iwlagn 0000:10:00.0: firmware: requesting iwlwifi-4965-2.ucode
iwlagn 0000:10:00.0: loaded firmware version 228.57.2.23

Cheers,
FJP
