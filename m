Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbXG2FEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbXG2FEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 01:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXG2FE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 01:04:29 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:48143 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbXG2FE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 01:04:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAJ68q0arR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.19,194,1183359600"; 
   d="scan'208"; a="190514312:sNHT23488416"
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Diego Calleja <diegocg@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Jessup <jonathanjessup@gmail.com>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
X-Message-Flag: Warning: May contain useful information
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	<1185588279.1654.1.camel@localhost>
	<alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
	<Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
	<954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
	<alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr>
	<alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org>
	<20070728225148.a0e58fdd.diegocg@gmail.com>
	<Pine.LNX.4.64.0707282259220.15125@fbirervta.pbzchgretzou.qr>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 28 Jul 2007 22:04:14 -0700
Message-ID: <adaodhvu7g1.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jul 2007 05:04:15.0502 (UTC) FILETIME=[E9264AE0:01C7D19D]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > It's like CONFIG_HZ - more or less often debated, and now we have everyone
 > happy by giving them the choice.

That's an interesting analogy -- since really the right answer there
seems not to be modal at all, but rather to do CONFIG_NO_HZ.

 - R.
