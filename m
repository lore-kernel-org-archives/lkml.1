Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXL2E3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXL2E3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:29:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbXL2E2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:28:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbXL2E2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:28:53 -0500
Message-ID: <47747B3A.5090304@cinatas.ath.cx>
Date: Fri, 28 Dec 2007 05:27:38 +0100
From: Sascha Warner <prx@cinatas.ath.cx>
User-Agent: Thunderbird 2.0.0.9 (X11/20071207)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, WU Fengguang <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
References: <47742268.8040302@cinatas.ath.cx> <20071228150111.e9451632.akpm@linux-foundation.org>
In-Reply-To: <20071228150111.e9451632.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/B3cx/d244Ud55/V7HcJ0Rn+KMm9UOFnVAA4s
 AUwgofHFaxcA9WoOAH3woYgvhawHWOzNDAXIfCopIzfFPSeB61
 VPCbM4Sc66rQuuvdYbc3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 27 Dec 2007 23:08:40 +0100 Sascha Warner <prx@cinatas.ath.cx> wrote:
>
>   
>> Hi,
>>
>> I applied your patches to 2.6.24-rc6-mm1, but now I am faced with one
>> pdflush often using 100% CPU for a long time. There seem to be some rare
>> pauses from its 100% usage, however.
>>
>> On ~23 minutes uptime i have ~19 minutes pdflush runtime.
>>
>> This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo ~x64_64
>>
>> Let me know if you need more info.
>>
>>     
>
> (some) cc's restored.  Please, always do reply-to-all.
>   
Hi Wu,

Your latest patch does fix the seen pdflush 100% issue :)

P.S.: Andrew, sorry my subject pretended I was subscribed to lkml, I am not.
I hoped for the script at lkml to pull the threads together because of
the subject.

Thank you,
Sascha Warner
