Return-Path: <linux-kernel-owner+w=401wt.eu-S934048AbYEUBKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbYEUBKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbYEUBK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:10:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60169 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465AbYEUBKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=X+WzJ8ud3G5YpYcOv6l2Q1x9gPtTJLefd3WX774ajrb4zD8t4ZY2FKhe8scMWaVGDf8/dMB3zZLvTDt+vL44AMNGR4Vf+f3L+yrcdT1CdvWy3oLlIf2YL2+7f/tdI4uJp4ZRmYENbQoLwV3MuAAoX3KMIcoYJJ9OUJdqXayqTyI=
Message-ID: <48337671.1080807@googlemail.com>
Date: Wed, 21 May 2008 03:10:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10648] CONFIG_PRINTK_TIME broken on git HEAD ?
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>	 <7wuznNhcUqC.A.Xw.7sBMIB@albercik>	 <1211131275.6463.5.camel@lappy.programming.kicks-ass.net> <1211135855.6463.20.camel@lappy.programming.kicks-ass.net> <48336F0E.30006@googlemail.com>
In-Reply-To: <48336F0E.30006@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:

> Peter Zijlstra wrote:
> 
>> On Sun, 2008-05-18 at 19:21 +0200, Peter Zijlstra wrote:
>>> On Sun, 2008-05-18 at 13:13 +0200, Rafael J. Wysocki wrote:
>>>> This message has been generated automatically as a part of a report
>>>> of recent regressions.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> from 2.6.25.  Please verify if it still should be listed.
>>>>
>>>>
>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
>>>> Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
>>>> Submitter	: Gabriel C <nix.or.die@googlemail.com>
>>>> Date		: 2008-05-08 00:26 (11 days old)
>>>> References	: http://lkml.org/lkml/2008/5/7/352
>>>> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>>
>>>>
>>> Could people test this:
>>>
>>> git://git.kernel.org/home/peterz/git/linux-2.6-sched.git/ v2.6.26-rc2-group-load-balance
>>
>> Seems I got my own url wrong - the right one is:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git v2.6.26-rc2-group-load-balance
>>
>>
> 
> 
> Sorry for the lag , I'm gonna test this now and report back in a bit.


Peter thx , it fixes the problem for me.

Gabriel




