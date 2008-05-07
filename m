Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbYEGWXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbYEGWXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763134AbYEGWWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:22:46 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56572 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbYEGWWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:22:43 -0400
Message-ID: <48222BE9.4020808@keyaccess.nl>
Date: Thu, 08 May 2008 00:23:37 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de> <48222784.10506@keyaccess.nl>
In-Reply-To: <48222784.10506@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 00:04, Rene Herman wrote:

> On 07-05-08 23:41, Thomas Gleixner wrote:
> 
>>>> Clearing it in the cpuinfo is just a cosmetic side effect which does
>>>> no harm at all.
>>> Oh yes, it does. It makes people unaware that their CPUs _should_ be
>>> supporting PAT. The thing's not called /proc/kernelinfo for a reason.
>>
>> it's named /proc/cpuinfo
> 
> Exactly.

(yes, missed a "not" in the above).

Rene.
