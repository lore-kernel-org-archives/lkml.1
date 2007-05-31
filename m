Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXEaVGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXEaVGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXEaVG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:06:28 -0400
Received: from relay00.pair.com ([209.68.5.9]:4182 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750722AbXEaVG1 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:06:27 -0400
X-pair-Authenticated: 24.241.238.207
Message-ID: <465F38D1.1050506@cybsft.com>
Date: Thu, 31 May 2007 16:06:25 -0500
From: "K.R. Foley" <kr@cybsft.com>
Organization: Cybersoft Solutions, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: patch-2.6.21.3-rt9 misnamed?
References: <465EE33B.4070502@cybsft.com> <20070531153821.GA712@elte.hu> <465EFE31.30904@cybsft.com> <20070531200109.GA8715@elte.hu>
In-Reply-To: <20070531200109.GA8715@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * K.R. Foley <kr@cybsft.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * K.R. Foley <kr@cybsft.com> wrote:
>>>
>>>> Ingo,
>>>>
>>>> I believe that patch-2.6.21.3-rt9 is misnamed. It applies cleanly to 
>>>> 2.6.21 but seems to contain stuff that is already in 2.6.21.3.
>>> yes - it includes all of 2.6.21.3.
>>>
>>> 	Ingo
>>>
>> So actually it is not really misnamed, it's just done a bit 
>> differently than previous versions. Sorry.
> 
> yeah. Maybe we should make the 2.6.21.3 -rt patches relative to 2.6.21.3 
> - but that would be one extra patching step for people who already have 
> a 2.6.21 tree. But ... maybe that makes the most sense after all.
> 
> 	Ingo
> 

Well don't change any of this on my account. Whatever is easiest for
everyone else is fine with me. I was merely pointing it out to possibly
help someone else out rather than as a complaint.

-- 
   kr
