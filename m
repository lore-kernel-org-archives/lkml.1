Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbXG3IVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbXG3IVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXG3IVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:21:11 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:37162 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbXG3IVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:21:10 -0400
X-Greylist: delayed 2196 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 04:21:09 EDT
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "'Adrian Bunk'" <bunk@stusta.de>,
       "Mikael Starvik" <mikael.starvik@axis.com>
Cc: "dev-etrax" <dev-etrax@axis.com>, <linux-kernel@vger.kernel.org>
Subject: RE: cris port lacks a merge?
Date: Mon, 30 Jul 2007 09:44:19 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C668030B5C6F@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C66804AE23FB@exmail1.se.axis.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I will make another try soon.

The problem is that every time I try the following happens:

1. I download the bleeding edge latest stuff that you can get
2. I prepare and submit patches
3. I get replies with comments on my patches
4. I fix the patches.
5. I get told that the patches are against a too old version
6. Repeat from 1.

But I will continue to start making attempts to send patches upstreams
again.

Patches are also available at http://developer.axis.com

/Mikael

-----Original Message-----
From: Adrian Bunk [mailto:bunk@stusta.de] 
Sent: Sunday, July 15, 2007 2:04 PM
To: Mikael Starvik
Cc: dev-etrax; linux-kernel@vger.kernel.org
Subject: cris port lacks a merge?


Hi Mikael,

the last maintainer update to arch/cris/ was two years ago and it seems 
code like e.g. the config variable ETRAX_ARCH_V32 is missing.

I assume there is there some external tree you use that contains updates?
If yes, can you submit the changes for inclusion into the upstream kernel?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

