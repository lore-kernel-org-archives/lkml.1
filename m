Return-Path: <linux-kernel-owner+w=401wt.eu-S1030228AbXAaQRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030228AbXAaQRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030229AbXAaQRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:17:17 -0500
Received: from cir-el.real.com ([207.188.23.7]:53681 "EHLO cir-el.real.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030228AbXAaQRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:17:16 -0500
Message-ID: <45C0C13A.40209@real.com>
Date: Wed, 31 Jan 2007 08:18:02 -0800
From: Martin Seidl <mseidl@real.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>	<20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de>
In-Reply-To: <p7364anpkz5.fsf_-_@bingen.suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When you say newbie?  Do you mean coding newbie?  Or... just someone who
hasn't done a driver before?

either way I'd like to be somewhat involved in the process so I see how
things are done.

--martin

Andi Kleen wrote:
> Greg KH <greg@kroah.com> writes:
>> What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
>> that floppy.c is?  Do you want everyone just to run screaming from
>> kernel development never to be seen again?
> 
> Doing a from-scratch rewrite of floppy.c only supporting new
> hardware and no obscure formats ("newfloppy.c") would be an excellent 
> newbie project imho.  This means for someone who is still pretty
> new, but wants to get their fingers wet with more complicated changes.
> 
> Then over time (old-)floppy.c could be phased out.
> 
> If anybody is interested...? (non newbies would be welcome too of course)
> 
> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
