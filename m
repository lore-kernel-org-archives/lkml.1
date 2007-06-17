Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbXFQOEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbXFQOEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbXFQOD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:03:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42340 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbXFQOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:03:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46753F07.6050806@s5r6.in-berlin.de>
Date: Sun, 17 Jun 2007 16:02:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Adrian Bunk <bunk@stusta.de>, Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
References: <200704291849.23197.rjw@sisk.pl>	 <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>	 <E1HyipW-0005wJ-0Q@flower>	 <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>	 <20070615234202.GP3588@stusta.de>	 <20070616013236.GA16016@flower.upol.cz>	 <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de>	 <467501D0.3090203@googlemail.com> <20070617124508.GV3588@stusta.de> <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
In-Reply-To: <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> "choose minor evil to prevent a greater one"

The measurement of "evil" is subjective.  That's why there are releases
with known regressions.
-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/
