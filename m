Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbXI1OTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbXI1OTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXI1OTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:19:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36653 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbXI1OTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:19:02 -0400
Date: Fri, 28 Sep 2007 16:19:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
In-Reply-To: <20070928110310.GF2443@hacking>
Message-ID: <Pine.LNX.4.64.0709281617430.25099@fbirervta.pbzchgretzou.qr>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928093902.GA28455@elte.hu>
 <20070928100024.GB18163@shadowen.org> <200709281246.45546.borntraeger@de.ibm.com>
 <20070928110310.GF2443@hacking>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 28 2007 19:03, WANG Cong wrote:
>
>Maybe checkpatch.pl needs an option '-W' to turn on/off those vexed "noise".
>(It seems that 'q|quiet' doesn't do as much as what it hints.)

Make checkpatch.pl a C language parser, then it can handle
all the whitespace violations without false positives. :-)
