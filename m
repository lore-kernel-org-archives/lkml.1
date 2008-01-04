Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYADL0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYADL0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYADL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:26:39 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37572 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYADL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:26:38 -0500
Message-ID: <477E17B7.7040404@s5r6.in-berlin.de>
Date: Fri, 04 Jan 2008 12:25:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use __u64 in aligned_u64's definition
References: <Pine.LNX.4.64.0801022135500.14900@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.00.0801021251040.32517@woody.linux-foundation.org> <Pine.LNX.4.64.0801022225460.14900@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.00.0801021341070.3010@woody.linux-foundation.org> <Pine.LNX.4.64.0801022243450.14900@fbirervta.pbzchgretzou.qr> <20080104110333.GA26149@elte.hu>
In-Reply-To: <20080104110333.GA26149@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jan Engelhardt <jengelh@computergmbh.de> wrote:
>> Well you can also apply it right now,
...
> We are in -rc6 and all the codebase is in deep freeze. Delay 
> your patch to when the 2.6.25 merge window starts

I suggest Jan adds the explanation from
http://lkml.org/lkml/2008/1/2/263 to the changelog and resends the patch
to Andrew + LKML.
-- 
Stefan Richter
-=====-==--- ---= --=--
http://arcgraph.de/sr/
