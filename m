Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXDIT6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXDIT6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbXDIT6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:58:50 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:39187 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287AbXDIT6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:58:49 -0400
Date: Mon, 09 Apr 2007 15:58:40 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
In-reply-to: <20070409175009.GB10189@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Dave Dillow <dave@thedillows.org>,
       ray-gmail@madrabbit.org, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Message-id: <200704091558.40225.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
 <200704091305.08779.gene.heskett@gmail.com> <20070409175009.GB10189@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> > Andrew has already sent a revert patch to Linus and it's in -rc6.
>> > The commit is below.
>>
>> Is this not the patch that reverts it?  I want the patch that put it
>> in, because that will be a one time churn and be done with it,
>> hopefully for good. [...]
>
>any patch can be reverse-applied by doing "patch -R ...".

Duh!, old farts short term memory strikes again.  However I finally do 
have that nailed down to 238 now.  I had a typu in my modprobe.conf  :(

>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
	WARNING TO ALL PERSONNEL:

Firings will continue until morale improves.
