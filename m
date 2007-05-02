Return-Path: <linux-kernel-owner+w=401wt.eu-S2992908AbXEBIsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992908AbXEBIsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992913AbXEBIsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:48:54 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:55970 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992908AbXEBIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cC1Ol54O6DqycDZUffH48u+wMGa8/TL5iIAxrywnfBcC3IQzVparziuLF0wnoNrD4nMOPiB539mgkrPcoRsbYzbyZI9kAn+9oxQoZRxmjVtXbfQlMOFizLiAi3vPVCLDM0dPGyjt6X9Ru8QZEnOpbGliQPxFdh/edceXFhC/PIc=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] CFS scheduler, -v8
Date: Wed, 2 May 2007 04:48:45 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
References: <20070501212223.GA29867@elte.hu> <200705020403.35385.gene.heskett@gmail.com> <1178093536.8926.47.camel@Homer.simpson.net>
In-Reply-To: <1178093536.8926.47.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705020448.46255.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007, Mike Galbraith wrote:
>On Wed, 2007-05-02 at 04:03 -0400, Gene Heskett wrote:
>> I just checked my logs, and it appears my workload didn't trigger this one
>> Mike.
>
>It's just a build time compiler warning.

Duh.  I have a couple of pages of "may be used uninitialized" warnings.
Including one in serial.c for the raw channel.  And I have a bit of trouble 
there too.  Related?  Dunno.

>> Ingo asked for a 0-100 rating, where 0 is mainline as I recall it, and 100
>> is the best of the breed.  I'll give this one a 100 till something better
>> shows up.
>
>Ditto.  (so far... ya never know;)
>
>	-Mike

Yup, this is sweet so far. :-)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The vulcan-death-grip ping has been applied.
