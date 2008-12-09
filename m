Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYLIMOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYLIMOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 07:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYLIMOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 07:14:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:48107 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYLIMON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 07:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s1Cs3rp3dA0WSJMWvkvXcphiPPrmQY//BSPlQuV9hrE3k0GAl4Y1Qa1To+br61Z3Xe
         B34EuqRySX5VI6IgbCKKETCjGGcjMp2HTzWpBK8qDgk+uAaFgbasrxs2DJdF+gIntZq/
         8IjbKbQzR9cMXuseHhcFo3buQ20/wUBnTBkdA=
Message-ID: <4d8e3fd30812090414v2e7a4bc3h621ca56e91ae367@mail.gmail.com>
Date: Tue, 9 Dec 2008 13:14:11 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v2
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       dada1@cosmosbay.com, robert.richter@amd.com, arjan@infradead.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       paulus@samba.org
In-Reply-To: <20081209.032955.101042639.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081209110246.GC21618@elte.hu>
	 <20081209.031120.90683825.davem@davemloft.net>
	 <20081209112225.GD21618@elte.hu>
	 <20081209.032955.101042639.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 12:29 PM, David Miller <davem@davemloft.net> wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 9 Dec 2008 12:22:25 +0100
>
>>
>> * David Miller <davem@davemloft.net> wrote:
>>
>> > From: Ingo Molnar <mingo@elte.hu>
>> > Date: Tue, 9 Dec 2008 12:02:46 +0100
>> >
>> > >
>> > > * stephane eranian <eranian@googlemail.com> wrote:
>> > >
>> > > > > There's also more generic x86 support: all 4 generic PMCs of Nehalem
>> > > > > / Core i7 are supported - i've run 4 instances of KernelTop and they
>> > > > > used up four separate PMCs.
>> > > >
>> > > > Core/Atom have 5 counters, Nehalem has 7. Why are you not using all of
>> > > > them already?
>> > >
>> > > no, Nehalem has 4 generic purpose PMCs and 3 fixed-purpose PMCs (7
>> > > total),
>> >  ...
>> > > Saying that it has 7 is misleading.
>> >
>> > Even you just did.
>>
>> which portion of my point stressing the general purpose attribute was
>> unclear to you?
>
> I'm just teasing you because you picked a trite point from stephane's
> email instead of the meat later on, which I would have found more
> interesting to hear you comment on.

I'm interested in Ingo's comments on that argument as well but I don't
feel the need to act like were are all in a kindergarten.

You are two astonishing developers and I'm sure you can demonstrate
that you can have a pure technical discussion on this topic as you did
several times in the past.

Regards,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
http://mypage.vodafone.it/
