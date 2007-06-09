Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbXFINmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbXFINmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 09:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbXFINmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:42:06 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56837
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbXFINmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:42:05 -0400
Date: Sat, 9 Jun 2007 06:41:01 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading andmanipulation,pathname
 matching
In-Reply-To: <20070609073556.b58ca755.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706090640050.6313@asgard.lang.hm>
References: <20070609011022.ac332fc7.seanlkml@sympatico.ca>
 <Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm> <20070609014454.2f1f2f91.seanlkml@sympatico.ca>
 <Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm> <20070609032822.bc420a84.seanlkml@sympatico.ca>
 <200706092026.CJH55869.NGPNtMTS@I-love.SAKURA.ne.jp>
 <20070609073556.b58ca755.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Sean wrote:

> On Sat, 9 Jun 2007 20:26:57 +0900
> Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp> wrote:
>
>> Sean wrote:
>>> All of a sudden you've implemented the main features of AA with very
>>> few changes to the kernel.  It should be more maintainable, and much
>>> easier to get accepted into the kernel.
>> Do you agree with passing "struct vfsmount" to VFS helper functions and LSM hooks
>> and introducing d_namespace_path() so that the AA extension can calculate the requested pathname
>> and map the requested pathname to SELinux's labels?
>>
>
> Frankly i'm not in a position to judge, but if that's the best way to provide
> the desired functionality, then it sounds good.  But please make sure you
> bounce this all off someone who actually knows what they're talking about. ;o)
> Really I was just casually following along this ongoing conversation and had
> a more conceptual/design question about how things were implemented.  A few
> people explained how AA labelling at "runtime" wasn't conceptually very
> different than what SELinux did.  All that begged the question as to why
> that functionality couldn't just be tacked on to SELinux?

Sean,
   since you aren't in a position to judge what's acceptable and I'm not in 
a position to change code our exchange is pointless.

I apologize to the list for the excessive messasges.

David Lang
