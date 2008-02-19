Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbYBSPYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbYBSPYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYBSPYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:24:41 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:45201
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYBSPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:24:40 -0500
Message-ID: <47BAF4B6.5090307@qumranet.com>
Date: Tue, 19 Feb 2008 17:24:38 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86, kvm: add ad_mask static inline
References: <1203361968.5757.42.camel@brick> <47BA95B0.4050806@qumranet.com> <1203434097.7766.6.camel@brick>
In-Reply-To: <1203434097.7766.6.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Tue, 2008-02-19 at 10:39 +0200, Avi Kivity wrote:
>   
>> Harvey Harrison wrote:
>>     
>>> Replaces open-coded mask calculation in macros.
>>>
>>>   
>>>       
>> Please regenerate against kvm.git (patch 2 doesn't apply; see 
>> http://kvm.qumranet.com/kvmwiki/Code).  Also please copy 
>> kvm-devel@lists.sourceforge.net on kvm patches.
>>
>> (first patch applied)
>>
>>     
>
> Against what branch?
>
>   

master

-- 
error compiling committee.c: too many arguments to function

