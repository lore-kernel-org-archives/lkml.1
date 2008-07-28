Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYG1KLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYG1KLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYG1KK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:10:57 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:47093 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYG1KK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:10:56 -0400
X-Auth-Info: pmXRje/kpb4aBNXxwfzHvzrR1UBQnKBUErsdJIIn8lw=
X-Auth-Info: pmXRje/kpb4aBNXxwfzHvzrR1UBQnKBUErsdJIIn8lw=
X-Auth-Info: pmXRje/kpb4aBNXxwfzHvzrR1UBQnKBUErsdJIIn8lw=
X-Auth-Info: pmXRje/kpb4aBNXxwfzHvzrR1UBQnKBUErsdJIIn8lw=
X-Auth-Info: VfZmJB96k+c/q6+a9a7/4p7Gsiik1Qz95toSenhVj4Y=
X-Auth-Info: VfZmJB96k+c/q6+a9a7/4p7Gsiik1Qz95toSenhVj4Y=
X-Auth-Info: VfZmJB96k+c/q6+a9a7/4p7Gsiik1Qz95toSenhVj4Y=
X-Auth-Info: VfZmJB96k+c/q6+a9a7/4p7Gsiik1Qz95toSenhVj4Y=
X-Auth-Info: VfZmJB96k+c/q6+a9a7/4p7Gsiik1Qz95toSenhVj4Y=
Message-ID: <488D9B95.2050305@grandegger.com>
Date: Mon, 28 Jul 2008 12:12:37 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>, Carsten Emde <ce@ceag.ch>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: Re: 2.6.24.7-rt16
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>	 <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>	 <488D7F5D.8090400@grandegger.com> <1217238516.6331.10.camel@twins>
In-Reply-To: <1217238516.6331.10.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-07-28 at 10:12 +0200, Wolfgang Grandegger wrote:
> 
>> Thomas Gleixner wrote:
> 
>>>      - powerpc ftrace backport (tglx)
>> Backport? It's not yet available for 2.6.25.
> 
> But it seems to be upstream ;-)
> 
> root@twins:/mnt/build/linux-2.6# find arch/powerpc/ | grep ftrace
> arch/powerpc/kernel/ftrace.c

Ah, right. I obviously missed that.

Wolfgang.
