Return-Path: <linux-kernel-owner+w=401wt.eu-S1751273AbZE2EGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbZE2EGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 00:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZE2EGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 00:06:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47090
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbZE2EGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 00:06:00 -0400
Date: Thu, 28 May 2009 21:05:59 -0700 (PDT)
Message-Id: <20090528.210559.137121893.davem@davemloft.net>
To: jeremy@goop.org
Cc: mingo@elte.hu, dan.magenheimer@oracle.com, avi@redhat.com,
       George.Dunlap@eu.citrix.com, xen-devel@lists.xensource.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, keir.fraser@eu.citrix.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian.Pratt@citrix.com, xen-users@lists.xensource.com,
       ksrinivasan@novell.com, EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com, npiggin@suse.de
Subject: Re: Xen is a feature
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A1F302E.8030501@goop.org>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
	<20090528001350.GD26820@elte.hu>
	<4A1F302E.8030501@goop.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Thu, 28 May 2009 17:45:34 -0700

> Ingo Molnar wrote:
>> Xen changes - especially dom0 - are overwhelmingly not about improving
>> Linux, but about having some special hook and extra treatment in
>> random places - and that's really bad.
>>   
> 
> You've made this argument a few times now, and I take exception to it.
> 
> It seems to be predicated on the idea that Xen has some kind of niche
> usage, with barely more users than Voyager.  Or that it is a parasite
> sitting on the side of Linux, being a pure drain.

I don't see Ingo's comments, whether I agree with them or not, as
an implication of Xen being niche.  Rather I see his comments as
an opposition to how Xen is implemented.

> We're taking your technical critiques very seriously, of course, and I
> appreciate any constructive comment.  But your baseline position of
> animosity towards Xen is unreasonable, unfair and unnecessary.

I don't see any animosity at all in what Ingo has said.
