Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbYCXUxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbYCXUxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYCXUw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:52:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbYCXUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:52:57 -0400
Date: Mon, 24 Mar 2008 13:50:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
In-Reply-To: <47E807EE.2030902@m3y3r.de>
Message-ID: <alpine.LFD.1.00.0803241348510.2775@woody.linux-foundation.org>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
 <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Ahh, I was reading email in the wrong order, so I saw your other email 
  first. ]

On Mon, 24 Mar 2008, Thomas Meyer wrote:
>
> Yes. With this patch applied the error messages doesn't appear anymore.

Does the firewire port work too? 

			Linus
