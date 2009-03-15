Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZCOJs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZCOJs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZCOJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:48:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40179 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbZCOJso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:48:44 -0400
Date: Sun, 15 Mar 2009 10:48:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090315094807.GB21169@elte.hu>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au> <49BCC7C8.2020503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BCC7C8.2020503@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Kevin Shanahan wrote:
>> On Sat, 2009-03-14 at 20:20 +0100, Rafael J. Wysocki wrote:
>>   
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.27 and 2.6.28.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>>> be listed and let me know (either way).
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
>>> Subject		: KVM guests stalling on 2.6.28 (bisected)
>>> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
>>> Date		: 2009-01-17 03:37 (57 days old)
>>> Handled-By	: Avi Kivity <avi@redhat.com>
>>>     
>>
>> No further updates since the last reminder.
>> The bug should still be listed.
>>   
>
> I've looked at the traces but lack the skill to make any sense 
> out of them.

Do you have specific questions about them that we could answer?

	Ingo
