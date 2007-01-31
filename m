Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbXAaGte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbXAaGte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 01:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXAaGte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 01:49:34 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:31652 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbXAaGtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 01:49:33 -0500
In-Reply-To: <20070131062607.GA14548@kroah.com>
References: <20070130012904.GA9617@kroah.com> <f2b55d220701301827h703d24eele941c86046caa9e7@mail.gmail.com> <20070131062607.GA14548@kroah.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C027A21A-42C4-4901-96F0-82E36CAD6C22@kernel.crashing.org>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Free Linux Driver Development!
Date: Wed, 31 Jan 2007 00:48:29 -0600
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31, 2007, at 12:26 AM, Greg KH wrote:

> On Tue, Jan 30, 2007 at 06:27:29PM -0800, Michael K. Edwards wrote:
>> On 1/29/07, Greg KH <greg@kroah.com> wrote:
>>> Free Linux Driver Development!
>>>
>>> Yes, that's right, the Linux kernel community is offering all  
>>> companies
>>> free Linux driver development.  ...
>> [snip]
>>> [1] for the CPUs that support the bus types that your device  
>>> works on.
>>
>> Bravo!  Now, is there a message in the same spirit that can be
>> tailored to embedded space, especially to SoC vendors and (even more
>> importantly) their customers?  Something along the lines of:
>>
>> "We understand that embedded hardware is frequently buggy and that  
>> SoC
>> vendors are doing well if their own internal software people can get
>> enough help from the chip guys to bring up enough customer-driven use
>> cases to win a few design-ins.
>>
>> We sympathize with embedded developers who stay up nights with an
>> O-scope and a JTAG emulator reverse-engineering the hardware  
>> behavior,
>> trying to figure out which this order of operations works and this
>> other one doesn't.
>>
>> We have the software tools and the competence to quantify the
>> potential gains from current toolchains and kernels, aggressive
>> compilation options, and in-tree power/latency management strategies,
>> so that you can build a business case against "fire and forget" SDKs
>> based on ancient compilers, obsolete kernels, and unmaintained
>> out-of-tree patches.
>>
>> We will help platform integrators bridge the gap between the chip
>> architects' claims about device performance and the condition in  
>> which
>> the BSP guys toss drivers over the fence.
>>
>> You can hang onto the hardware and profit from coaching and code
>> review, or you can send us a board and whatever doco you've got, and
>> we'll figure it out.
>>
>> All we ask is that 1) SoC vendors authorize customers to do an NDA
>> with OSDL and pass vendor NDA material along to us; 2) when the
>> product ships, all participants are free to exercise GPL rights with
>> respect to the chip support and driver code produced; and 3) platform
>> integrators cooperate with the rework usually needed as code merges
>> towards Linus's tree."
>>
>> Or is this a pipe dream?
>
> Oh, I would love to see something like that happen :)
>
> As I come from an embedded background, I love to see Linux running in
> tiny systems.  So anything I can do to help out with that I'd love to
> offer.
>
> But being able to read the minds of SOC hardwre engineers and  
> decode all
> of the documentation errors they produce is enough to drive one crazy,
> my condolences go out to everyone in that situation...
>
> good luck,
>
> greg k-h

Thanks.  It gets even better when they change things between  
revisions of the same HW block.

Out of interest are you was this geared to any particular SoC's/ 
architectures?

- k
