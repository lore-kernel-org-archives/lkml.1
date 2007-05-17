Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbXEQSRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbXEQSRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXEQSRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:17:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:53431 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbXEQSRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:17:09 -0400
Message-ID: <464C9C22.102@qumranet.com>
Date: Thu, 17 May 2007 21:17:06 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: strange GPF when panicing under kvm
References: <464B9E19.6050902@goop.org> <464C574C.5020201@qumranet.com> <464C8DBA.80506@goop.org> <464C9126.3090907@qumranet.com> <464C9A9B.7040608@goop.org>
In-Reply-To: <464C9A9B.7040608@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu, 17 May 2007 21:17:06 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>   
>> That means pause isn't set for interception.
>>
>> I ran a small test program, and it liked pause as well.
>>
>> Can you send me your vmlinuz?  I wasn't able top reproduce the problem
>> with mine.
>>
>>     
>
> I can't repro it anymore either.
>   

Even better.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

