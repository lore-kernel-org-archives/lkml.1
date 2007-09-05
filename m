Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXIERpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXIERpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXIERpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:45:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44787 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbXIERpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:45:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46DEEAC1.7020900@s5r6.in-berlin.de>
Date: Wed, 05 Sep 2007 19:43:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Teulings <rael@edge.ping.de>, michal.k.k.piotrowski@gmail.com,
       rbrito@gmail.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>	<6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>	<20070827065246.GA21220@ime.usp.br>	<46D279E8.10001@edge.ping.de>	<46D72BC6.3020809@edge.ping.de>	<20070905100754.57ab4e3e.akpm@linux-foundation.org> <20070905102824.a481060c.randy.dunlap@oracle.com>
In-Reply-To: <20070905102824.a481060c.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 5 Sep 2007 10:07:54 -0700 Andrew Morton wrote:
>>> So here is the output from dmesg that suggested to me that firewire 
>>> might be a problem:
>> Straightforward regression, two reporters, nothing happening.
> 
> (material for ksummit discussion, e.g.)

It's a simple thing in this incident:  I don't read all posts on LKML.
But I typically catch everything where I am in the CC list thanks to the
wonders of sieve.  Andrew, thanks for putting me in the CCs.
-- 
Stefan Richter
-=====-=-=== =--= --=-=
http://arcgraph.de/sr/
