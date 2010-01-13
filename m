Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824Ab0AMIGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0AMIGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085Ab0AMIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:06:13 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:33568 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0AMIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:06:12 -0500
Message-ID: <4B4D7EED.7010207@xenontk.org>
Date: Wed, 13 Jan 2010 13:36:05 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, yakui.zhao@intel.com
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>	<CXIfLt-ygXM.A.DAC.zglSLB@chimera>	<4B4AB589.7080004@xenontk.org>	<201001112052.57339.rjw@sisk.pl> <20100112101446.7fac096e@jbarnes-piketon>
In-Reply-To: <20100112101446.7fac096e@jbarnes-piketon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 11:44 PM, Jesse Barnes wrote:
> On Mon, 11 Jan 2010 20:52:57 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
>> On Monday 11 January 2010, David John wrote:
>>> On 01/11/2010 04:26 AM, Rafael J. Wysocki wrote:
>>>> This message has been generated automatically as a part of a
>>>> report of regressions introduced between 2.6.31 and 2.6.32.
>>>>
>>>> The following bug entry is on the current list of known
>>>> regressions introduced between 2.6.31 and 2.6.32.  Please verify
>>>> if it still should be listed and let me know (either way).
>>>>
>>>>
>>>> Bug-Entry	:
>>>> http://bugzilla.kernel.org/show_bug.cgi?id=14897
>>>> Subject		: i915: Commit 0e442c60 causes flickering
>>>> Submitter	: David John <davidjon@xenontk.org>
>>>> Date		: 2009-12-09 17:26 (33 days old)
>>>> First-Bad-Commit:
>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
>>>> References	:
>>>> http://marc.info/?l=linux-kernel&m=126037889600769&w=4
>>>>
>>>>
>>>>
>>>
>>> Still present in 2.6.33-rc3.
>>
>> Thanks for the update.
> 
> David I guess you weren't on the bug cc list so you didn't see Yakui's
> question.  I just attached a patch to it as well.  Please check it out.
> 

Hi Jesse,

I've updated the bug report with more info. If you have any other ideas,
I can test those also.

Regards,
David.
