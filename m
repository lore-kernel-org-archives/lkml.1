Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZJFS6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZJFS6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZJFS6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:58:02 -0400
Received: from mail.lang.hm ([64.81.33.126]:39283 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbZJFS6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:58:01 -0400
Date: Tue, 6 Oct 2009 11:56:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Frans Pop <elendil@planet.nl>,
       mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <alpine.LFD.2.01.0910061040200.3432@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0910061155140.11706@asgard.lang.hm>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain> <200910061909.35878.elendil@planet.nl>
 <4ACB7F9C.9090606@s5r6.in-berlin.de> <alpine.LFD.2.01.0910061040200.3432@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Linus Torvalds wrote:

> On Tue, 6 Oct 2009, Stefan Richter wrote:
>
>> Frans Pop wrote:
>>> Developers are supposed to be able to take care of themselves;
>>
>> _People who build kernels from sources which differ from releases_ are
>> supposed to take care of themselves.
>
> Yes. If you compile a random development kernel, you'd better then not
> come and whine to developers about how you can't tell which version it is.
> Especially when we do have things like CONFIG_LOCALVERSION_AUTO exactly
> for this case.
>
> But it's possible that people really just weren't aware of that whole
> LOCALVERSION_AUTO thing.

I will say that I was not aware of it, and I've been using kernel.org 
kernels for many years.

I'm glad to see it there. enabling it by default would probably be a very 
good thing.

David Lang
