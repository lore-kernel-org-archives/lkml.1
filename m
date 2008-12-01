Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYLAKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYLAKrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYLAKrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:47:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYLAKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:47:05 -0500
Message-ID: <4933BF71.6010801@redhat.com>
Date: Mon, 01 Dec 2008 12:41:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, lguest@ozlabs.org,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, jeremy@xensource.com,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104150729.GC21470@localhost>	 <20081129154516.GA26579@mailshack.com> <49318871.8010501@redhat.com>	 <200812011502.37170.rusty@rustcorp.com.au>	 <4933AD51.5000202@redhat.com> <aa79d98a0812010232s4a2f13f9v2a34c4368047d000@mail.gmail.com>
In-Reply-To: <aa79d98a0812010232s4a2f13f9v2a34c4368047d000@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On Mon, Dec 1, 2008 at 12:24 PM, Avi Kivity <avi@redhat.com> wrote:
> ...
>   
>> Once it's done there's no reason not to commit it.  But the effort expended
>> to do it is gone, without any measurable return.
>>
>>     
> ...
>
> Not sure Avi what you mean but as far as I know Alexander is working on
> this file so he need just time to finish (we all have other duties you know :).
> So I think the idea Peter proposed could be merged right after Alexander
> will have finished. At least the Peter's suggestion was recorded in this
> thread which means it will *not* be lost eventually. Or you meant something
> else (yep, I could have it translated plain wrong)?
>   

What I mean is that hpa's patch makes the kernel better, so it should be 
applied.  I'm not sure what else Alexander is working on, but I do hope 
the improvements will be more concrete.

(Alexander, I apologise for being so discouraging; but I really feel 
these improvements are marginal)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

