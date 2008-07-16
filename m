Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbYGPD2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbYGPD2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYGPD2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:28:12 -0400
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:22216 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754158AbYGPD2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:28:11 -0400
X-YMail-OSG: Mi3bcq8VM1n__70jk39lr.dqMQuDoFITZQk77.i575eqQA6UaW5updyoWLMfRhoA7XYdnGC3HPLHZvjdoVtFB7q2mQbNG5RtgvBlAnBoOBNOIuP_tNYnt9J_hcwuCdWgs.dJdsugTh0rVsojWZryApGk
X-Yahoo-Newman-Property: ymail-3
Message-ID: <487D6AB9.7080700@schaufler-ca.com>
Date: Tue, 15 Jul 2008 20:27:53 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Tiago Assumpcao <tiago@assumpcao.org>
CC: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
References: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org> <487D3A13.3040507@assumpcao.org> <20080716010836.GL8185@mit.edu> <487D547C.7060909@assumpcao.org>
In-Reply-To: <487D547C.7060909@assumpcao.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiago Assumpcao wrote:
> Theodore Tso wrote:
>> Look if you want this, pay $$$ to a distribution and get their
>> supported distribution.  It costs time and effort to classify bugs as
>> security related (or not), (...)
>
> That's fallacious. Assuming that you have good programmers, and you 
> do, it's of very low cost the act of identifying what *is likely to 
> be* a security bug.

That is based on lots and lots of assumptions that are just not true.
Ted Tso, Stephen Smalley and I are all recognized as security experts
and we can't even agree on whether sockets are objects or not, much
less what constitutes a security bug and even less what is likely to
be a security bug. Goodness, there are some of us who would argue
that since DNS is itself a security bug it is just not possible for
DNS to have a security bug, as an example.

> In most cases, they are easy to spot.

Err, no, in the kernel environment a real security flaw is likely to
be pretty subtle.

> And, hey, we are not asking for an absurd amount of care. You must not 
> pay $200 /hour for someone to review your software. All I, personally, 
> ask for is that the basic attention is given. With this simple act, 
> I'm sure you would cover the majority of the bugs.
>
>> It will cost you money, but hey, the people who want
>> this sort of thing typically are willing to pay for the service.
>>
>
> So, only those willing to pay have the right of respect? Because, you 
> see, this is rather a matter of respect with those who choose to use 
> your solution. And, no, the "free will" argument does not qualify 
> herein. My mother is not aware of your absurd acts.
>
>> I'll note that trying to classify bugs as being "security-related" at
>> the kernel.org level often doesn't help the distro's, since many of
>> these bugs won't even apply to whatever version of the kernel the
>> distro's snapshotted 9-18 months ago.  So if the distro snapshotted
> > 2.6.18 in Fall 2006, and their next snapshot will be sometime two
>> years later in the fall of this year, they will have no use for some
>> potential local denial of service attack that was introduced by
>> accident in 2.6.24-rc3, and fixed in 2.6.25-rc1.  It just doesn't
>> matter to them.
>
> I don't follow what you have just said. What is the problem with 
> "versioning" and the strictness of its relation to bugs, security or not?
>
>>
>> So basically, if there are enough kernel.org users who care, they can
>> pay someone to classify and issue CVE numbers for each and every
>> potential "security bug" that might appear and then disappear.
>
> I think, CVE registration or the alike would be too much for what I 
> call "act of decency". A single parenthesis note on the bug itself 
> would be of great help and of small effort.
>
>
> --t
>
>
>
>
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

