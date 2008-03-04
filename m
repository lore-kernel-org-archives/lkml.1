Return-Path: <linux-kernel-owner+w=401wt.eu-S1763366AbYCDIie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763366AbYCDIie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762580AbYCDIhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:37:46 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:52846
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762460AbYCDIhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:37:45 -0500
Message-ID: <47CD0A57.3010701@qumranet.com>
Date: Tue, 04 Mar 2008 10:37:43 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: replace remaining __FUNCTION__ occurances
References: <1204573043.3266.50.camel@brick> <47CC6422.5030806@qumranet.com> <1204577802.22933.6.camel@brick> <20080304081658.GB5689@elte.hu>
In-Reply-To: <20080304081658.GB5689@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
>
>   
>>> Please send the kvm parts against kvm.git instead of mainline to 
>>> avoid needless merges.
>>>       
>> Sure, I'll send a split out patch against kvm.git
>>
>> Ingo, do you mind chopping the diff to apply just the x86-specific 
>> stuff or do you want a split patch as well?
>>     
>
> no need, i picked up the non-kvm bits. Avi, will you pick up the KVM 
> bits or should Harvey resend?
>   

Harvey sent a rebased version, which I applied.

-- 
error compiling committee.c: too many arguments to function

