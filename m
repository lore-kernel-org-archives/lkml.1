Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZLEDTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZLEDTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 22:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbZLEDTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 22:19:14 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:46161 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbZLEDTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 22:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vo8O/9Zt3HLjZwnmMirlU9IGby7jtzIUCQgm/mAmPcK031f8hfxyd2SpMpP+VIN4mB
         ixS32SR57jcOmVqbnVL3nIobgdy/Nmxfqpc/0E5BerAIlgmXp3BaeXGfxUUqV26wXFRF
         geO/7jAEO2Thknys6CVZq/rx5UltqqV6igXBE=
MIME-Version: 1.0
In-Reply-To: <4BDB13256095B24D9644F65379E604265C12@orsmsx505.amr.corp.intel.com>
References: <3877989d0908272018va6ee8f7n7ab2838fdf1b26e6@mail.gmail.com>
	 <20090828062212.GB11552@elte.hu>
	 <3877989d0912032329u7c05a761wfdd5c7000b43218d@mail.gmail.com>
	 <4BDB13256095B24D9644F65379E604265C12@orsmsx505.amr.corp.intel.com>
Date: Sat, 5 Dec 2009 11:19:18 +0800
Message-ID: <3877989d0912041919i458300d7ydce73cf77979dad3@mail.gmail.com>
Subject: Re: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then 
	enable ftrace for ia64
From: Luming Yu <luming.yu@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, Felix Blyakher <felixb@sgi.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, Bob Picco <bob.picco@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 3:16 AM, Luck, Tony <tony.luck@intel.com> wrote:
> Luming,
>
> Can you send the config file that you used to test this.

yes, will send my config later when back to office.

>
> I turned on a bunch of LOCKDEP related things, but I may have
> stumbled into areas that aren't working yet because my kernel
> didn't boot (or say anything on the console, even with early
> serial uart console enabled).

Please also send your config to me, let me check
what could make that happen.

>
> I'd like to take this patch so we can fix it up with incremental
> patches ... but I'd like a better idea of what works now and
> what doesn't.
>
> Thanks
>
> -Tony

Thanks.
Luming
