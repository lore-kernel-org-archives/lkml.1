Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYC3Jdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYC3Jdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 05:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYC3Jdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 05:33:41 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:40203 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYC3Jdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 05:33:40 -0400
Date: Sun, 30 Mar 2008 15:03:31 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Richard Jonsson <richie@coderworld.net>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Keyboard weirdness: keys get stuck
Message-ID: <20080330093331.GE30270@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <47EEA097.5000701@coderworld.net> <47EEC51C.2060806@coderworld.net> <20080329234358.GA28667@linux.vnet.ibm.com> <47EED858.7010605@coderworld.net> <47EEE2E0.4070009@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EEE2E0.4070009@coderworld.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 01:46:24AM +0100, Richard Jonsson wrote:
> Richard Jonsson skrev:
>> Dhaval Giani skrev:
>>> Can you check if you have CONFIG_GROUP_SCHED enabled? If so, can you
>>> disable and test?
>>>
>>
>> Yes it's enabled, will try without groupsched.
>
> Same behavior without group_sched
>

Is it easy to reproduce? Would it be possible for you to bisect?

Thanks,
-- 
regards,
Dhaval
