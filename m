Return-Path: <linux-kernel-owner+w=401wt.eu-S1763018AbXGFQup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763018AbXGFQup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbXGFQug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:50:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54347 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbXGFQuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:50:35 -0400
In-Reply-To: <200707052116.16681.vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: 7eggert@gmx.de, Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nix <nix@esperi.org.uk>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF2C158685.9A0F2BFA-ON88257310.005AD54A-88257310.005C8528@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Fri, 6 Jul 2007 09:50:35 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V80_M5_05202007|May 20, 2007) at
 07/06/2007 12:50:37,
	Serialize complete at 07/06/2007 12:50:37
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>the 
>maintainers of util-linux have well versed autotool people at their 
disposal, 
>so i really dont see this as being worrisome.

As long as that is true, I agree that the fact that so many autotool 
packages don't work well is irrelevant.

However, I think the difficulty of using autotools (I mean using by 
packagers), as evidenced by all the people who get it wrong, justifies 
people being skeptical that util-linux really has that expertise 
available.  Also, many open source projects are developed by a large 
diverse group of people, so even if there exist people who can do the 
autotools right, it doesn't mean they'll be done right.

One reason I try to minimize the number of tools/skills used in 
maintaining packages I distribute is to enable a larger group of people to 
help me maintain them.

