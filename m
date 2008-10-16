Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbYJPRdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbYJPRdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbYJPR3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:29:22 -0400
Received: from mail.lang.hm ([64.81.33.126]:43864 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbYJPR3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:29:20 -0400
Date: Thu, 16 Oct 2008 10:30:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: el es <el_es_cr@yahoo.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <loom.20081016T092338-594@post.gmane.org>
Message-ID: <alpine.DEB.1.10.0810161027590.9226@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com> <loom.20081016T075618-911@post.gmane.org> <48F704E6.2010409@zytor.com> <loom.20081016T092338-594@post.gmane.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, el es wrote:

> H. Peter Anvin <hpa <at> zytor.com> writes:
>> el es wrote:
> [snip]
>>> - informative : the ww and tt numbers are the week numbers of when the actual
>>>
>>> release HAPPENED, not when it is predicted.
>>>
>>
>> Which really sucks for dealing with future releases.
>>
>
> Why ?
> What do you mean by 'future releases' ?
> Can you predict exactly when the next release will happen ? The current practice
> of -rcX shows clearly you cannot.

that's the point

> Moreover, with my idea you could easily say, which stable release is still
> supported (and how old its mainline really was) up to the week, which IMHO is
> granular enough.

huh?? kernels are not supported for X amount of time, so this isn't 
relevant information for support. kernels are 'supported' until some time 
after the next kernel is released.

> Also you could for sure say, that e.g. a device/software that hit market in say
> December this year, will be compatible with e.g. 2.09.XX+ - look at users POV.

no you can't, the fact that a kernel was released in December and the 
product was released in November tells you nothing about the probability 
that that hardware is supported by that kernel.

you can't even say that a kernel released in 2009 supports hardware 
released in 2007.

David Lang

> Current scheme is great, established and understandable, but sucks at this
> point : for any product, be it hardware or software, you need to print both its
> date of creation AND the minimum kernel that supports it. With my idea, it is
> only the date you need.
>
>> 	-hpa
>>
>
> Lukasz
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
