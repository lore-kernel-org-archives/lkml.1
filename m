Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbZCPJ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbZCPJ5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760110AbZCPJul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:50:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38615 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760179AbZCPJuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:50:40 -0400
Message-ID: <49BE20B2.9070804@redhat.com>
Date: Mon, 16 Mar 2009 11:49:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kevin Shanahan <kmshanah@ucwb.org.au>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>	 <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au>
In-Reply-To: <1237107837.27699.27.camel@kulgan.wumi.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Shanahan wrote:
> On Sat, 2009-03-14 at 20:20 +0100, Rafael J. Wysocki wrote:
>   
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.27 and 2.6.28.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>> be listed and let me know (either way).
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
>> Subject		: KVM guests stalling on 2.6.28 (bisected)
>> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
>> Date		: 2009-01-17 03:37 (57 days old)
>> Handled-By	: Avi Kivity <avi@redhat.com>
>>     
>
> No further updates since the last reminder.
> The bug should still be listed.
>
>   

Does the bug reproduce if you use the acpi_pm clocksource in the guests?


-- 
error compiling committee.c: too many arguments to function

