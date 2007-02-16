Return-Path: <linux-kernel-owner+w=401wt.eu-S1422950AbXBPBaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422950AbXBPBaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422995AbXBPBaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:30:10 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:41220 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1422963AbXBPBaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:30:09 -0500
Date: Thu, 15 Feb 2007 17:14:33 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Scott Preece <sepreece@gmail.com>
cc: Miguel Ojeda <maxextreme@gmail.com>, v j <vj.linux@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> 
 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> 
 <20070215061149.GE15654@redhat.com>  <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
  <20070215165339.GB5285@thunk.org>  <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
  <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com>
 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Scott Preece wrote:

> On 2/15/07, Miguel Ojeda <maxextreme@gmail.com> wrote:
>
>> Stupid, maybe. But some people just don't want closed-source
>> projects/companies like yours using their free work, without any kind
>> of feedback. Some others don't care, but they could in the future, as
>> it is their code, and that is your risk.
>> 
> ---
>
> So, how are such companies any different from the myriad individuals
> and companies that use Linux on the desktop or in their server rooms
> without ever modifying it and who also contribute nothing back to the
> community? They are also, in many (most?) cases taking advantage of
> the free (as in beer) nature of Linux - saving money by using the work
> of others without returning anything, but the product builders seem to
> get a lot more abuse...

if they don't modify it and don't distribute it there is not issue.

it's people who modify it (by creating a derived work) and then redistribute it 
that get the abuse.

now if your kernel module is _not_ a derived work (and such things can exist, 
much as some people don't want to admit it) then you don't have a problem 
either.

but the definition of what is a derived work is not cut-and-dry, and that is 
where you have to get lawyers involved if you care.

I am _not_ a lawyer, but there are two basic approaches you can take

1. The easy way out is to release the module source under a GPL compatable 
license.

2. If you don't want to do this you need to involve the lawyers to tell you if 
they think that your development work is derived or not, and even if you decide 
that it isn't you may have to prove that it's not in court, potentially in 
multiple juristrictions (in the relativly unlikly event that you offend enough 
different kernel developers that they take the time to sue you individually).

I believe that it's extremely unusual for a lawyer to give a cut-and-dry answer 
to a liability question, so from a liability point of view it seems clear cut.

what your company needs to decide is if they consider the risk to their "IP" to 
be outweight the costs of #2, including the risk that the lawyer is wrong and a 
cour may order you to stop distributing the product unless you comply with the 
GPL.

David Lang
