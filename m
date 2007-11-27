Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbXK0WNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbXK0WNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbXK0WNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:13:08 -0500
Received: from mx2.go2.pl ([193.17.41.42]:49492 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755514AbXK0WNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:13:07 -0500
Message-ID: <474C9714.1080308@o2.pl>
Date: Tue, 27 Nov 2007 23:15:48 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
References: <20071125172237.GC6658@kernel.dk> <20071127070912.GB1735@ff.dom.local> <20071127164723.GA3406@stusta.de>
In-Reply-To: <20071127164723.GA3406@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote, On 11/27/2007 05:47 PM:

> On Tue, Nov 27, 2007 at 08:09:12AM +0100, Jarek Poplawski wrote:
>> On 25-11-2007 18:22, Jens Axboe wrote:
>>> On Sun, Nov 25 2007, Adrian Bunk wrote:
>> ...
>>>> Is there any technical reason why we need 4 different schedulers at all?
>>> Until we have the perfect scheduler :-)
>> IMHO this is not enough yet. There is something called "the right
>> of choice",
> 
> That's a common misconception about open source software:
> 
> There is nothing like a "right of choice".
> There is a "right to change the source code".


Maybe you are right, maybe I've used wrong words... But, e.g., google
pretends to know about this first right too. And I've meant generally,
not about open software.

> 
> This means you cannot demand from anyone to offer any choices, but you 
> can fork the code yourself and use and distribute modified code 
> containing any choices you consider reasonable.
 

I don't demand anything. I've only expressed my personal opinion
that usually (if possible) the choice is better than no choice.
And, since I don't know anything in open source forbiding this, I
can ask, why you demand to take away offered choices; actually, I
think it would be much easier if you could fork the other way...

>> and, it seems, things are usually far from perfect
>> where this right is not respected.
> 
> That's wrong.
> 
> It's actually often much worse to have different choices with different 
> features and bugfixes than having one version that contains all features 
> and all bugfixes.
> 


It's only a part of the theory: usually it's easier to find some bugs
if there is a possibility to compare a performance with other options;
there is also kind of stimulation and flow of new ideas between them.
Otherwise it's not so hard to overlook some stagnation.

Regards,
Jarek P.
