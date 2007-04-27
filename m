Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbXD0EMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbXD0EMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXD0EMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:12:18 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:62998 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbXD0EMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:12:17 -0400
Message-ID: <46317819.5020304@bigpond.net.au>
Date: Fri, 27 Apr 2007 14:12:09 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01sl.mx.bigpond.com from [138.130.231.4] using ID pwil3058@bigpond.net.au at Fri, 27 Apr 2007 04:12:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Apr 2007, Peter Williams wrote:
>> The 2.6.21 kernel is hanging during the post boot phase where various daemons
>> are being started (not always the same daemon unfortunately).
>>
>> This problem was not present in 2.6.21-rc7 and there is no oops or other
>> unusual output in the system log at the time the hang occurs.
> 
> Can you use "git bisect" to narrow it down a bit more? It's only 125 
> commits, so bisecting even just three or four kernels will narrow it down 
> to a handful

Yes.  I'm just in the process of reading up on how to do the bisecting 
now.  Should have an answer in a few hours, I guess.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
