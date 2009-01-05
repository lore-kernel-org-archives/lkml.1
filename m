Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZAENWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZAENWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZAENWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:22:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:48601 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZAENWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VwO+G+0If/PTAicw+TquCQfhh46pReJpzGGZ5k3Usm5hJaJoqzhm9DXOpFz9hkk1QT
         o97Fd9kY8QhyJPxeKB1oURgeUyIg0g5o8J/dkB08yjn+gAStzc57IamvkMI6xR66GPtE
         NVRqOUsTcp5WE01LoTPaCC6ogh91DDg20wfno=
Message-ID: <3f9a31f40901050522h4389894w69e41fa9645ce8c@mail.gmail.com>
Date: Mon, 5 Jan 2009 18:52:38 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090105131521.GC6014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231066898.27852.29.camel@jaswinder.satnam>
	 <20090104172114.GA32425@elte.hu>
	 <3f9a31f40901040957g5a391408u5cda93c4acb66e9d@mail.gmail.com>
	 <20090104203433.GC1132@elte.hu>
	 <1231131855.16019.2.camel@jaswinder.satnam>
	 <20090105131521.GC6014@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 6:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
>
>> On Sun, 2009-01-04 at 21:34 +0100, Ingo Molnar wrote:
>> > yeah - i mentioned it to you before that there are such cases.
>> >
>>
>> OK, so here is new patch excluding smp.h:
>
> Could you please instead fix the smp.h assumption so that we dont hit this
> in the future? Then we can apply your original patch.

Sure, I will do it.

> [ Do you need the
> specific .config that hits this? Can dig it out if necessary. ]

If you provide me that .config file then it will be very helpful for
cross-checking.

JSR
