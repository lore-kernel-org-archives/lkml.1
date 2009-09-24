Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZIXJLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZIXJLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZIXJLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:11:11 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54985 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752574AbZIXJLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:11:10 -0400
Message-ID: <4ABB37A6.2050505@evidence.eu.com>
Date: Thu, 24 Sep 2009 11:11:02 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: GeunSik Lim <leemgs1@gmail.com>
CC: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
References: <1253615424.20345.76.camel@Palantir> <49b7c2350909231734h936f76fq5cdb056ff6144076@mail.gmail.com>
In-Reply-To: <49b7c2350909231734h936f76fq5cdb056ff6144076@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GeunSik Lim ha scritto:
> On Tue, Sep 22, 2009 at 7:30 PM, Raistlin <raistlin@linux.it> wrote:
>   
>> The project is hosted at the following URL:
>>
>>  http://www.evidence.eu.com/sched_edf.html
>>
>>     
> Hi Raistlin,
>
> Thank you for challenge to support EDF on Linux 2.6 in private.
>
> You have to modify  git address of schedtool-edf at
> http://www.evidence.eu.com/sched_edf.html correctly.
>
> before) git clone git://feanor.sssup.it/sched-tool-edf.git
> after   ) git clone git://feanor.sssup.it/schedtool-edf.git
>
> ----- http://www.evidence.eu.com/sched_edf.html
> ---------------------------------
> Usage with schedtool
>
>  To easily test SCHED_EDF you can use our modified version of
> schedtool as explained below.
> For instance, to run a simple yes program with period 100000us and
> budget 25000us, just type the following commands:
>
> git clone git://feanor.sssup.it/sched-tool-edf.git * <-- Here, change
>   
Fixed.

Many thanks,

             Claudio

