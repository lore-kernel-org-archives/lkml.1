Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXLSILf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXLSILf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 03:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXLSILZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 03:11:25 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:43010 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbXLSILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 03:11:25 -0500
Message-ID: <4768D216.3000904@lwfinger.net>
Date: Wed, 19 Dec 2007 00:11:02 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: mvtodevnull@gmail.com
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Daniel Walker <dwalker@mvista.com>, Ray Lee <ray-lk@madrabbit.org>,
       =?ISO-8859-1?Q?Simon_Holm_Th=F8gerse?= =?ISO-8859-1?Q?n?= 
	<odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
 to mutex
References: <20071213003028.676998182@mvista.com>	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>	 <47637FDA.2030303@lwfinger.net>	 <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>	 <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>	 <47661CA1.3080808@lwfinger.net>	 <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>	 <47671F5F.5020400@lwfinger.net>	 <520b60a90712171834n61b09f23rc4c907ce3e8458cf@mail.gmail.com> <520b60a90712181812l3fd6c4cbicece82a4487d0587@mail.gmail.com>
In-Reply-To: <520b60a90712181812l3fd6c4cbicece82a4487d0587@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mvtodevnull@gmail.com wrote:
> Larry, thanks for being so patient so far. Tomorrow I plan to take my
> laptop to somewhere with coffee and a wireless network. For now
> though, can you tell me if these messages could be related:
> PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0

I don't know what these regions are, but I doubt if they have any relation to your problem.
> 
> or could tsc being marked as unstable have anything to do with the
> speed of network transfers?

Absolutely not.

Larry


