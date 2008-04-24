Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYDXIi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYDXIi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYDXIiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:38:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55476 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYDXIiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EFYGD4zmI5x3GcE2ayXK9iOcClZsFvsS9jPTYslrHUkVCaEbgN77/CRY6siNdUvf/yOkkTXfeZ7rNGAj5pK6+E4YKliKGh6BY9SL29pflMYkrr2wkSSJlyAQdJbCJ5lTK0t5rmM6Ap3j1ZcBy4gOtH+kdy9wlIvyDz6K4HInQBY=
Date: Thu, 24 Apr 2008 12:38:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Message-ID: <20080424083806.GB7749@cvg>
References: <1208917076.9212.721.camel@pmac.infradead.org> <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com> <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com> <480F7C11.8040302@zytor.com> <20080423185859.GB7713@cvg> <480FBA73.2090209@zytor.com> <1208990882.9212.855.camel@pmac.infradead.org> <aa79d98a0804232025p45feb6e7t4058f2eeec88f127@mail.gmail.com> <1209015106.9212.898.camel@pmac.infradead.org> <48101BE2.9020506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48101BE2.9020506@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Apr 23, 2008 at 10:34:26PM -0700]
> David Woodhouse wrote:
>> On Thu, 2008-04-24 at 07:25 +0400, Cyrill Gorcunov wrote:
>>> Ok, lets drop these all and forget :)
>> We still want to shift the definition of X86_VM_MASK inside __KERNEL__,
>> don't we?
>
> Yes.
>
> 	-hpa
>

I've just posted the patch, please review (i'm to go out of
my work machine so if there would be any objections I read
them today evening, thanks)

		- Cyrill -
