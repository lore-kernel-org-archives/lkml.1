Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYGPF0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYGPF0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYGPF0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:26:47 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:29829 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751087AbYGPF0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:26:46 -0400
X-YMail-OSG: j7XkAWIVM1my_XMGOSA7koOmJtp6sJLUnFoCJ16IZx3ApbcK68.WUgEn_oaeXAjjHfn1ZniZwB3yF9oWcrhHhlve0chRQw2Bx3dXyiZ.v1S3yLzm0fs6X84QzipucYd0wxg-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <487D8687.7090003@schaufler-ca.com>
Date: Tue, 15 Jul 2008 22:26:31 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Tiago Assumpcao <tiago@assumpcao.org>
CC: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
References: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org> <487D3A13.3040507@assumpcao.org> <20080716010836.GL8185@mit.edu> <487D547C.7060909@assumpcao.org> <487D6AB9.7080700@schaufler-ca.com> <487D756E.50506@assumpcao.org>
In-Reply-To: <487D756E.50506@assumpcao.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiago Assumpcao wrote:
> Casey Schaufler wrote:
>> Ted Tso, Stephen Smalley and I are all recognized as security experts
>> and we can't even agree on whether sockets are objects or not, much
>> less what constitutes a security bug and even less what is likely to
>> be a security bug. Goodness, there are some of us who would argue
>> that since DNS is itself a security bug it is just not possible for
>> DNS to have a security bug, as an example.
>>
>>> In most cases, they are easy to spot.
>>
>> Err, no, in the kernel environment a real security flaw is likely to
>> be pretty subtle.
>
> You do not hesitate in categorizing yourself as something as obscure 
> as... what's that term again? "Expert".

Actually, I always hesitate before calling myself an expert,
in spite of the credentials I have to back the title. Too
many people seem to think that if you disagree with their
point of view you can't know what you're talking about.

> But then you fail on basic pragmatism when attempting to define what, 
> nearly always, is a true or false question?

HeeHeeHee. Security questions are almost never true or false,
black or white, on or off. SPAM is *the* major computer security
issue and it has nothing at all to do with computers or security.
Is a use of strcpy() a security vulnerability? Sure it can be,
but in reality it almost never is, but the hysteria associated
with buffer overruns gave it a bad oder.

> Jeez ;)

It's not so bad. We'll be OK. Really.

