Return-Path: <linux-kernel-owner+w=401wt.eu-S1031334AbXD2Wsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031334AbXD2Wsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031450AbXD2Wsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:48:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:34673 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031334AbXD2Wsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GI2zSZOGRosjhLGYtJaXfpQW8s5MohwNw2a0tbAwbR/ooe00mAxzk7ykT9lQZeXt8htRoAXYQrh27pgbSNCbqy32tF+OaooTanL4u8KI8r2hD/DQl9q5ncxpA31Ww0zRuPN2e1u4utuW4lCTzFkhgzKV5Goac5AehpAOvi70iww=
Message-ID: <6bffcb0e0704291548o764fdf2fva6e5e6f839e9790e@mail.gmail.com>
Date: Mon, 30 Apr 2007 00:48:28 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Linux 2.6.21
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Adrian Bunk" <bunk@stusta.de>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070429223741.GB714@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070429180909.GA30604@one.firstfloor.org>
	 <20070429201729.GQ3468@stusta.de>
	 <20070429225657.a501ab5a.diegocg@gmail.com>
	 <20070429211028.GT3468@stusta.de>
	 <6bffcb0e0704291416u402668ffo9bcaafb389228981@mail.gmail.com>
	 <20070429212128.GU3468@stusta.de>
	 <1177883521.5791.156.camel@localhost.localdomain>
	 <20070429221958.GX3468@stusta.de>
	 <1177886010.5791.166.camel@localhost.localdomain>
	 <20070429223741.GB714@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/07, Andi Kleen <andi@firstfloor.org> wrote:
> > Right. Simply because these lists are assembled by someone
> >
> > - who knows how to pick that reports from the mailinglists
> > - who knows how to sort them in a useful way
> > - who knows how to add the relevant folks on CC
>
> That all needs to be done by someone initially yes. But then tracking what happens
> afterwards is something that can be distributed. A difficult bug can take a long
> time to resolve and generate a lot of messages; you don't want to require
> the initial sorter to handle all that too.
>
> It's much more scalable to let the developers update the state themselves
> then once they handle the bug.

The actual list of known regressions is wiki based. Everyone can
update bug status, add references etc.

>From time to time, I'll send this list to right people.

>
> -Andi
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
