Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXEJD5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXEJD5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXEJD5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:57:05 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:33761 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754463AbXEJD5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:57:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Y/0HoqsKiimoo7EK2ll1gdfvvLzt5ExSOHTUflVMmTAqvurr7V6HmotX4ffzbGZ63VHEUNpX4pdSxdsrWzQGSx1jpp+RS1OURt1QaSD76+54h8j4VSI8ybvjERlk7yK8WtF/5rk4x/DP8XvlYsHfmeUa2FsIBOGvPh+ey0Zmgvw=  ;
X-YMail-OSG: 1HdINiUVM1l0Xnt8FTJNLEg2dhrEsUQhrlINa8pOWAJF1kGMRMaSr1wKeWkzTYNOD_zRK3wDPw--
Message-ID: <46429801.8030202@yahoo.com.au>
Date: Thu, 10 May 2007 13:56:49 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org>	 <200705100928.34056.kernel@kolivas.org>	 <464261B5.6030809@yahoo.com.au>	 <200705101134.34350.kernel@kolivas.org> <46427BDB.30004@yahoo.com.au> <2c0942db0705092048m38b36e7fo3a7c2c59fe1612b2@mail.gmail.com>
In-Reply-To: <2c0942db0705092048m38b36e7fo3a7c2c59fe1612b2@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 5/9/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> You said it helped with the updatedb problem. That says we should look at
>> why it is going bad first, and for example improve use-once algorithms.
>> After we do that, then swap prefetching might still help, which is fine.
> 
> 
> Nick, if you're volunteering to do that analysis, then great. If not,
> then you're just providing a airy hope with nothing to back up when or
> if that work would ever occur.

I'd like to try helping. Tell me your problem.


> Further, if you or someone else *does* do that work, then guess what,
> we still have the option to rip out the swap prefetching code after
> the hypothetical use-once improvements have been proven and merged.
> Which, by the way, I've watched people talk about since 2.4. That was,
> y'know, a *while* ago.

What's wrong with the use-once we have? What improvements are you talking
about?


> So enough with the stop energy, okay? You're better than that.

I don't think it is about energy or being mean, I'm just stating the
issues I have with it.

-- 
SUSE Labs, Novell Inc.
