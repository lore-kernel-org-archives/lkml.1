Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYGRIXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYGRIXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYGRIX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:23:28 -0400
Received: from smtp03.uc3m.es ([163.117.176.133]:43186 "EHLO smtp03.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYGRIX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:23:27 -0400
Date: Fri, 18 Jul 2008 10:23:18 +0200
Message-Id: <200807180823.m6I8NIo27365@inv.it.uc3m.es>
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
To: linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
X-Newsgroups: gmane.linux.kernel
In-Reply-To: <20080717224041.GM31126@csclub.uwaterloo.ca>
User-Agent: tin/1.4.4-20000803 ("Vet for the Insane") (UNIX) (Linux/2.2.15 
	(i686))
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-13.7660 TC:1F TRN:22 TV:5.5.1026(16038.005)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080717224041.GM31126@csclub.uwaterloo.ca> Lennart wrote:
> On Thu, Jul 17, 2008 at 11:05:07PM +0100, Alastair Stevens wrote:
>> Forgive me if I missed it, but I've not seen any suggestions along the lines
>> of this: how about just dropping the now-meaningless '.6' from the version
>> string and retaining the rest. In other words:
>> 
>>    2.27
>>    2.27.1
>>    ...
>>    2.28
>>    2.28.1
>>    2.28.2
>> 
>> That way you continue the series in a meaningful way, whilst reverting to a
>> neater 3-level numbering scheme again. Perhaps you could make 2.[6.]30 the
>> switchover point....

> So what makes the 6 meaningless and the 2 meaningful and worth keeping?

Nothing. Drop both.

  2.6.28 -> 2.8.0

could be a useful switch point.

> It does nothing for Linus's dislike of large numbers either.

The above does.

Peter
