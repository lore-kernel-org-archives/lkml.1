Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXHOIKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXHOIKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXHOIKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:10:42 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37252 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbXHOIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:10:40 -0400
Message-ID: <46C2B4FE.3080703@s5r6.in-berlin.de>
Date: Wed, 15 Aug 2007 10:10:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Joe Perches <joe@perches.com>, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [70/2many] MAINTAINERS - ARPD SUPPORT
References: <46bff8e8.HhTQ7TBPy1zkcNfh%joe@perches.com>	<20070813114942.04a5483c@the-village.bc.nu>	<1187019966.10249.75.camel@localhost>	<20070813173522.685dab9e@the-village.bc.nu>	<1187024659.10249.125.camel@localhost> <20070813185148.16308985@the-village.bc.nu>
In-Reply-To: <20070813185148.16308985@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> > Actually I think the entire thing is a
>> > bad idea but thats another matter.

> Working off the git tree as it shows who actually is making
> changes/updating stuff recently and why which is a major clue when
> tracing bugs

Adrian Bunk wrote in http://lkml.org/lkml/2007/6/30/107 :
| I don't see how git could tell you to Cc net patches to
| netdev@vger.kernel.org.

Ditto with problem reports.

For example, Cc'ing linux1394-devel on FireWire topics is a lot more
important than Cc'ing me.
-- 
Stefan Richter
-=====-=-=== =--- -====
http://arcgraph.de/sr/
