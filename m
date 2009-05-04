Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZEDPjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZEDPjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZEDPiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:38:51 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:34050 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZEDPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:38:51 -0400
Message-ID: <49FF0C4E.9090807@oracle.com>
Date: Mon, 04 May 2009 08:39:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rt: document the risk of small values in the bandwidth
 settings
References: <1241449678.7620.4931.camel@twins> <49FF0AFF.8030303@oracle.com> <1241451369.7620.4934.camel@twins>
In-Reply-To: <1241451369.7620.4934.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49FF0BEE.0066,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-05-04 at 08:34 -0700, Randy Dunlap wrote:
>>> +Fiddling with these settings can result in an unusable system, the knobs are
>>> +root only and assume root knows what he's on about.
>> I know that my English is limited, but I don't know what this means:
>>   "what he's on about."
> 
> Hehe, OK, how about we write it like:
> 
> Fiddling with these settings can result in an unstable system, the knobs are
> root only and assumes root knows what he is doing.
> 
> Does that work better for you?

Yes, thanks.

-- 
~Randy
