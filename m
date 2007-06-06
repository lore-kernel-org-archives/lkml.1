Return-Path: <linux-kernel-owner+w=401wt.eu-S965887AbXFFXB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965887AbXFFXB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965209AbXFFXBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:01:50 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5234 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965171AbXFFXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:01:49 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46673D3F.4040508@am.sony.com>
Date: Wed, 06 Jun 2007 16:03:27 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Big problems applying patch-2.6.21.3-rt9
References: <46673964.1000004@am.sony.com> <1181170799.4404.271.camel@chaos>
In-Reply-To: <1181170799.4404.271.camel@chaos>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 23:01:43.0501 (UTC) FILETIME=[A67757D0:01C7A88E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 2007-06-06 at 15:47 -0700, Tim Bird wrote:
>> Ingo,
>>
>> I saw lots of problems trying to apply the latest rt-preempt patch.
>> Maybe some bits got included by mistake in the patch?
>>
>> Here's what I saw:
>> $ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.3.tar.bz2
> 
> That should be 2.6.21.tar.bz2
> 
> The patch contains the .3 patch already. Unfortunately it used the wrong
> numbering scheme :(

I should have thought of that.  I noticed older patches were
against 2.6.21.

Thanks!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

