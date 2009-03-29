Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZC2IZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZC2IZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZC2IYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:24:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46352 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZC2IYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:24:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49CF2FD4.1010907@s5r6.in-berlin.de>
Date: Sun, 29 Mar 2009 10:22:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090323 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Hua Zhong <hzhong@gmail.com>
CC: "'Alex Goebel'" <alex.goebel@gmail.com>, "'Jeff Garzik'" <jeff@garzik.org>,
       "'Mark Lord'" <lkml@rtr.ca>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Matthew Garrett'" <mjg59@srcf.ucam.org>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Theodore Tso'" <tytso@mit.edu>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'David Rees'" <drees76@gmail.com>, "'Jesper Krogh'" <jesper@krogh.cc>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <49CD4DDF.3000001@garzik.org>	 <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <faa09fad0903280925t35a61c0aj2ae29d90337b9dab@mail.gmail.com> <01fd01c9afe9$f0b60030$d2220090$@com>
In-Reply-To: <01fd01c9afe9$f0b60030$d2220090$@com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hua Zhong wrote:
> Good point. We should throw away all the journaling junk and just go back 
> to ext2. Why pay the extra cost for something we shouldn't optimize for? 
> It's not like the kernel every crashes.

The previous two posts were about assumptions at the level of
application software, not at the kernel level.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
