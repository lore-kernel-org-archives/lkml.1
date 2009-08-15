Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZHOHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZHOHBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 03:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZHOHBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 03:01:21 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:36670 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZHOHBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 03:01:20 -0400
Message-ID: <4A865DA8.10009@xenontk.org>
Date: Sat, 15 Aug 2009 12:33:04 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1b3pre) Gecko/20090513 Thunderbird/3.0b2
MIME-Version: 1.0
To: Knut Petersen <Knut_Petersen@t-online.de>
CC: Fabio Comolli <fabio.comolli@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Subject: Re: drm / i915 performance problems
References: <4A853ED8.9030800@t-online.de> <1250250242.5241.1395.camel@twins>	 <4A856B13.90202@t-online.de> <b637ec0b0908140701r1d35e8daj15d47a246e865db8@mail.gmail.com> <4A85D23D.7030809@t-online.de>
In-Reply-To: <4A85D23D.7030809@t-online.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2009 02:38 AM, Knut Petersen wrote:
> Fabio Comolli schrieb:
>> If I remember correctly the solution was to add this repository:
>>
>>     http://download.opensuse.org/repositories/X11:/XOrg/openSUSE_11.1/
>>
>> to the repository list and then perform an update. Sorry but I left
>> Opensuse some months ago and my memory isn't helping a lot...
>>
>> Hope this helps. Regards,
>> Fabio
>>
>>   
> No, it does not help too much. I  updated to the  software provided there
> and the result is a X  server that crashes during startup ... :-(
> 
> Which X server is supposed to work with 2.6.30 (++) kernels on i915GM
> hardware?
> 

Your X server and the intel driver seems to be too old. Use the X server
1.6.2 rc1 with intel driver 2.7.0 and see if it works.

Regards,
David.
