Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZBXMKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZBXMKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZBXMKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:10:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44893 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZBXMKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:10:37 -0500
Message-ID: <49A3E38F.7080306@redhat.com>
Date: Tue, 24 Feb 2009 14:09:51 +0200
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
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>	 <LLno3yT_fnC.A.-RH.ZzzoJB@chimera> <1235437183.4988.2.camel@kulgan.wumi.org.au>
In-Reply-To: <1235437183.4988.2.camel@kulgan.wumi.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Shanahan wrote:
> On Mon, 2009-02-23 at 23:03 +0100, Rafael J. Wysocki wrote:
>   
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.27 and 2.6.28.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>> be listed and let me know (either way).
>>     
>
> Yes, the problem should still be listed.
> The bug is still present as recently as 2.6.29-rc5-00299-gadfafef.
>   

Did tracing turn anything up?

-- 
error compiling committee.c: too many arguments to function

