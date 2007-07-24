Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbXGXRq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbXGXRq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXGXRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:46:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41856 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbXGXRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:46:19 -0400
Date: Tue, 24 Jul 2007 19:46:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
In-Reply-To: <20070724102035.6447565c.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0707241946090.18990@fbirervta.pbzchgretzou.qr>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com>
 <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org>
 <46A5E034.2030205@shadowen.org> <Pine.LNX.4.64.0707241849340.18990@fbirervta.pbzchgretzou.qr>
 <20070724102035.6447565c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 24 2007 10:20, Randy Dunlap wrote:
>> As per Ingo Molnar [ http://lkml.org/lkml/2006/9/5/68 ],
>> all blocks in an if-else 'tree' should be {} if there is at least one
>> with more than two statements. (And I do not disagree.)
>
>You are actually referring to this commit:
>
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
>
>which did not appear on lkml for review... :(

You know who to blame.


	Jan
-- 
