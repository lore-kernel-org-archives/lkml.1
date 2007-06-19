Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbXFSPIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbXFSPIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759177AbXFSPIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:08:20 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48716 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157AbXFSPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:08:19 -0400
Message-ID: <4677F15D.6000903@s5r6.in-berlin.de>
Date: Tue, 19 Jun 2007 17:08:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
References: <4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <20070619140512.GA19904@flower.upol.cz>
In-Reply-To: <20070619140512.GA19904@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> On Tue, Jun 19, 2007 at 02:48:55PM +0200, Adrian Bunk wrote:
>> The -mm kernel already implements what your proposed PTS would do.
...
>> Plus it gives testers more or less all patches currently pending 
>> inclusion into Linus' tree in one kernel they can test.
> 
> Crazy development{0}. Somebody knows, that comprehensively testing
> hibernation is their thing. I don't care about it, i care about foo, bar.
> Thus i can apply for example lguest patches and implement and test new
> asm-offset replacement, *easily*.

That's right.  But the production of subsystem test patchkits is
volunteer work which will be hard to unify.

I'm not saying it's impossible to reach some degree of organized
production of test patchkits; after all we already have some
standardization regarding patch submission which is volunteer work too.
-- 
Stefan Richter
-=====-=-=== -==- =--==
http://arcgraph.de/sr/
