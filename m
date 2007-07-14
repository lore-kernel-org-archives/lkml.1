Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbXGNKCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbXGNKCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbXGNKCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:02:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:11255 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbXGNKCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:02:05 -0400
Date: Sat, 14 Jul 2007 12:02:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -mm merge plans for 2.6.23
In-Reply-To: <46980610.9080705@imap.cc>
Message-ID: <Pine.LNX.4.64.0707141200310.25352@fbirervta.pbzchgretzou.qr>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707101107340.11053@fbirervta.pbzchgretzou.qr>
 <46980610.9080705@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 14 2007 01:09, Tilman Schmidt wrote:
>Am 13.07.2007 11:46 schrieb Jan Engelhardt:
>> On Jul 10 2007 01:31, Andrew Morton wrote:
>> 
>>> use-menuconfig-objects-isdn-config_isdn_i4l.patch
>>>
>>> tilman didn't like it - might drop
>> 
>> Or replace by his suggestion patch ( http://lkml.org/lkml/2007/5/31/222 )
>
>That posting was just a change proposal for the drivers/isdn/Kconfig
>part, not a complete replacement for the entire patch. If you'd care to
>reissue that patch with the modification I proposed, I'll gladly ack it.
>Alternatively I can also send a full replacement patch if you prefer.

Since I did not really see much of a difference between our two
approaches, I'd be grateful if you could send a full replacement in
the hopes that I see the global picture.


Thanks,
	Jan
-- 
