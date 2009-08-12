Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbZHLXJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbZHLXJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZHLXJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:09:04 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57405 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbZHLXJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:09:03 -0400
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <20090812194838.GB12117@n2100.arm.linux.org.uk>
References: <20090806113104.GK31370@elf.ucw.cz>
	 <20090806120826.GC27773@flint.arm.linux.org.uk>
	 <4A7ACC8D.7030706@xenontk.org>
	 <20090806124048.GD27773@flint.arm.linux.org.uk>
	 <1249563730.10297.13.camel@Joe-Laptop.home>
	 <20090806133349.GF27773@flint.arm.linux.org.uk>
	 <1249568614.10297.20.camel@Joe-Laptop.home>
	 <20090806150322.GX2080@trinity.fluff.org>
	 <1249948147.8895.96.camel@Joe-Laptop.home>
	 <20090812115520.GI24339@elf.ucw.cz>
	 <20090812194838.GB12117@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 13 Aug 2009 00:04:37 +0100
Message-Id: <1250118277.12423.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 23:04:38.0521 (UTC) FILETIME=[446DC690:01CA1BA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 20:48 +0100, Russell King - ARM Linux wrote:
> On Wed, Aug 12, 2009 at 01:55:20PM +0200, Pavel Machek wrote:
> > I like that. Open lists are useful.
> 
> However, that is immaterial if no one is subscribed to it - in
> which case it acts as a black hole and a source of frustration
> for people.

I've been subscribed to linux-arm@vger since its creation in case anyone
was posting (though it seems that technically wasn't possible) and I'm
happy to reply to questions there.

> I haven't noticed a great rush of support for Joe's patch, which
> could mean that people here really aren't that bothered - maybe
> they just aren't "open list" zealots like some people seem to be.

Personally, I'm more in favour of open lists as I don't see any
advantage in having a moderated one. As for linux-arm@vger, if people
(cross-)post ARM specific patches and the ARM gatekeeper is not
subscribed, they could be lost unless other subscribers forward them to
you or the lak list (or your patch system).

An option would be to subscribe lak to linux-arm@vger so that messages
are directed to lak as well and maybe add an exception to not moderate
those coming via linux-arm@vger.

Anyway, if you (as gatekeeper) do not want to have anything to do with
the linux-arm@vger list (IOW "moderated list" zealot ;-)) I don't see
much point in updating the "ARM PORT" entry in the MAINTAINERS.

For the other ARM MAINTAINERS entries (e.g. specific boards), it is up
to the corresponding maintainers to add whatever lists they want, which
may include linux-arm@vger.

-- 
Catalin

