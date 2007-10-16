Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbXJPLBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbXJPLBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 07:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbXJPLBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 07:01:25 -0400
Received: from ns.kkc.fi ([62.148.199.203]:56984 "EHLO smtp.kkc.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbXJPLBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 07:01:25 -0400
Message-ID: <471499D8.8080103@mandriva.org>
Date: Tue, 16 Oct 2007 14:00:40 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler updates for v2.6.24
References: <20071015141723.GA29486@elte.hu> <47148CAC.8060603@mandriva.org> <20071016100848.GA17313@elte.hu> <20071016101239.GA17927@elte.hu>
In-Reply-To: <20071016101239.GA17927@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar skrev:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Thomas Backlund <tmb@mandriva.org> wrote:
>>
>>> How does this one compare to the v22 you released earlier ?
>> v22 has most of it included.
>>

OK, that's what I thought

>>> I'm thinking of backporting any fixes/optimizations to 2.6.22 (and 
>>> possibly 2.6.23)
>> i have already backported it as v22.1 - will release it within a few 
>> days. (once the currently open regressions have been fixed)
> 

OK

> i've uploaded what i have at the moment, to:
> 
>    http://people.redhat.com/mingo/cfs-scheduler/devel/sched-cfs-v2.6.23.1-v22.1-rc0.patch
> 
> 	Ingo

Big thanks for your work...

Now I just have to see if I can get it to work with the -hrt series and 
I'm really happy ;-)

--
Thomas
