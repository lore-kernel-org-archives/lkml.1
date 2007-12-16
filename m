Return-Path: <linux-kernel-owner+w=401wt.eu-S933600AbXLPOQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600AbXLPOQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 09:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXLPOQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 09:16:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761428AbXLPOQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 09:16:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sun, 16 Dec 2007 15:35:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Johannes Berg <johannes@sipsolutions.net>, Michael Buesch <mb@bu3sch.de>,
       Daniel Walker <dwalker@mvista.com>, Ray Lee <ray-lk@madrabbit.org>,
       Simon Holm =?iso-8859-15?q?Th=F8gersen?= <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org
References: <20071213003028.676998182@mvista.com> <200712160027.19950.mb@bu3sch.de> <1197813419.16079.66.camel@johannes.berg>
In-Reply-To: <1197813419.16079.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712161535.27261.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of December 2007, Johannes Berg wrote:
> 
> On Sun, 2007-12-16 at 00:27 +0100, Michael Buesch wrote:
> > On Sunday 16 December 2007 00:18:43 Rafael J. Wysocki wrote:
> > > Well, the only problem with that is I suspect there are some "newer" cards that
> > > work better with v3 firmware, although they are supposed to support both.
> 
> Impossible. The firmware is only the MAC.

OK

Thanks,
Rafael
