Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbXFSO13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbXFSO13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXFSO1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:27:22 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48596 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbXFSO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:27:21 -0400
Message-ID: <4677E7C3.90706@s5r6.in-berlin.de>
Date: Tue, 19 Jun 2007 16:27:15 +0200
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

On 6/19/2007 4:05 PM, Oleg Verych wrote:
> On Tue, Jun 19, 2007 at 02:48:55PM +0200, Adrian Bunk wrote:
>> The Debian BTS requires you to either write emails with control messages 
>> or generating control messages with external tools.
...
>> In Bugzilla the same works through a web interface.
...
> Basic concept of Debian BTS is what i've discovered after many useless
> hours i spent in Bugzilla. And this is mainly because of one basic
> important thing, that nobody acknowledged (for newbies, like me):
> 
> * E-Mail with useful MUAs, after it got reliable delivery MTAs with qmail
>   (or exim) is the main communication toolset.
> 
> Can't you see that from Linux's patch sending policy?

That's for developers, not for users.

There are different people involved in
  - patch handling,
  - bug handling (bugs are reported by end-users),
therefore don't forget that PTS and BTS have different requirements.
-- 
Stefan Richter
-=====-=-=== -==- =--==
http://arcgraph.de/sr/
