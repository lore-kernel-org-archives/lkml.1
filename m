Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZCHKFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZCHKFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZCHKFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:05:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZCHKFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:05:30 -0400
Message-ID: <49B39837.7010906@redhat.com>
Date: Sun, 08 Mar 2009 12:04:39 +0200
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
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>	 <pRIaSZpQ1ON.A.vrC.udarJB@chimera> <1236136099.7726.12.camel@kulgan.wumi.org.au>
In-Reply-To: <1236136099.7726.12.camel@kulgan.wumi.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Shanahan wrote:
> On Tue, 2009-03-03 at 20:41 +0100, Rafael J. Wysocki wrote:
>   
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>> be listed and let me know (either way).
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
>> Subject		: KVM guests stalling on 2.6.28 (bisected)
>> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
>> Date		: 2009-01-17 03:37 (46 days old)
>> Handled-By	: Avi Kivity <avi@redhat.com>
>>     
>
> Yes this should still be listed.
>
> The traces are there waiting to be looked at. If there's anything else I
> can do to help things along, please let me know.
>
>   

I was away on vacation, I'll try to look at the traces soon.  Help from 
the sched developers would be appreciated, though, as I doubt I have the 
skills to decypher them.


-- 
error compiling committee.c: too many arguments to function

