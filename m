Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbZIWTmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbZIWTmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZIWTmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:42:19 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:57246 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZIWTmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Eyf2XgxCOAEzE0g1cQrfbPbhTJ7sp3Ix51i1nj2vAr9Y4uNiE32Ob0FybyELZKPatu
         R9mkdU9bdZADziicfhRX/5P5bv6ld3aomgTpAcaHBeS3zLcF9MF2FXtF+EvxtAW4Z8E1
         LJtYKu7xvlYRaJ+r9Nk053VV4mqQZyAt2W3DU=
MIME-Version: 1.0
In-Reply-To: <520f0cf10909231240g11f5cafei5cbb4ed494eba76d@mail.gmail.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <20090922.153201.225375909.davem@davemloft.net>
	 <20090923114725.GB4132@elte.hu>
	 <20090923.111444.247045711.davem@davemloft.net>
	 <20090923193020.GA20934@elte.hu>
	 <520f0cf10909231240g11f5cafei5cbb4ed494eba76d@mail.gmail.com>
Date: Wed, 23 Sep 2009 21:42:21 +0200
Message-ID: <520f0cf10909231242r598b0bebtf99c8bea9690d11f@mail.gmail.com>
Subject: Re: mailing list for trace users
From: John Kacur <jkacur@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, acme@redhat.com, mhiramat@redhat.com,
       postmaster@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 9:40 PM, John Kacur <jkacur@gmail.com> wrote:
> On Wed, Sep 23, 2009 at 9:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * David Miller <davem@davemloft.net> wrote:
>>
>>> From: Ingo Molnar <mingo@elte.hu>
>>> Date: Wed, 23 Sep 2009 13:47:25 +0200
>>>
>>> > Could you please also create the linux-perf-users list, for perf
>>> > events and the perf tool related user questions? (We have asked for
>>> > this before but must have gotten lost somewhere)
>>>
>>> I think your communities are similar enough and small enough that you
>>> could share this list.
>>
>> It's two separate subsystems. There's a lot of non-tracing aspects of
>> performance events: it does profiling, counting, latency analysis, etc.
>> The tool is named 'perf', the subsystem is named 'performance events',
>> and the most typical workflows dont do any tracing.
>>
>> And i beg to differ about the size of the communities. It's just been
>> added upstream...
>>
>> Also, what is the policy for adding new lists to vger.kernel.org? If a
>> subsystem maintainer asks for a list named after a core kernel
>> subsystem, how frequently is it rejected, and on what basis?
>>
>> I find it sad that such an arbitrary looking negative decision from you
>> forces a user list away from vger. I wouldnt mind it to be closed if it
>> has no significant traffic after a year or lifetime or so - many vger
>> lists have almost no traffic to begin with.
>>
>> Also, i cannot help but to observe the fact that you've fought the
>> original perfcounters project in a very ugly and public way less than a
>> year ago. Dont you think that you 'deciding' this matter in such a
>> negative fashion is a conflict of interest?
>>
>>        Ingo
>
> Yikes - Ingo, I don't want to spawn a long thread here about what to
> call the list, but
> as a native English speaker, I think that "linux-trace-users" sounds
> much nicer than
> "linux-tracing-users".
>
> Perhaps, trace is an adjective describing the kind of users, in any
> case, it doesn't
> sound like "one trace" - so, could we go this one?
> (if you insist on linux-tracing then you have to drop the word "users")
>
> John
>

That's funny, boast about my credentials as a native English speaker, and then
make a mistake.

s/go this one/go with this one
