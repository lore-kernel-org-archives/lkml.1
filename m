Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYHGVZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYHGVZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbYHGVYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:24:49 -0400
Received: from gw.goop.org ([64.81.55.164]:41455 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002AbYHGVYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:24:47 -0400
Message-ID: <489B680D.7090601@goop.org>
Date: Thu, 07 Aug 2008 14:24:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
References: <aYipy-5FM-9@gated-at.bofh.it> <E1KRD1p-0001SX-0p@be1.7eggert.dyndns.org>
In-Reply-To: <E1KRD1p-0001SX-0p@be1.7eggert.dyndns.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>   
>> The idea I came
>> up with was to make a tmp.s file for every object just after it is compiled.
>>     
>
> make -j would cause these files to overwrite each other, wouldn't it?
>   

I'd assume the name is actually derived from the real filename...

    J

