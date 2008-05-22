Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYEVRwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYEVRwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYEVRvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:51:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:23294 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYEVRvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w5wzQu6wXOgUj7QjeWFeS18j3HcuXMepYrLKMow4NRLGs7vxw42IX+z28UQaOb2fx7KYmaHet89oASL88XC+amC8y1vQLKc9oH8Gj17uS29DeEXkmXHNgy0de8cs68OqgRpqbT3HM6Tbv1FU0+AJwYLjAS/V4g3oYLtaDeWN0Mo=
Message-ID: <32209efe0805221051v6a6d6071ub3ad22537a9a81b4@mail.gmail.com>
Date: Thu, 22 May 2008 10:51:49 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Number of bugs - statistics
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Bosko Radivojevic" <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080522173318.GD2727@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com>
	 <20080522144114.GC27301@cs181133002.pp.htv.fi>
	 <20080522075135.4933161c@infradead.org>
	 <20080522155425.GA2727@cs181133002.pp.htv.fi>
	 <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com>
	 <20080522165008.GB2727@cs181133002.pp.htv.fi>
	 <32209efe0805221008m1850730cxdb26d9bdeb9c43fc@mail.gmail.com>
	 <20080522173318.GD2727@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:33 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, May 22, 2008 at 10:08:49AM -0700, Natalie Protasevich wrote:
>> On Thu, May 22, 2008 at 9:50 AM, Adrian Bunk <bunk@kernel.org> wrote:
>>...
>> >> by various criteria: ALSA bugs
>> >> are numerous, which is not important for most enterprise server users
>> >> who would completely disregard this category, whereas desktop users
>> >> will probably concentrate on those more than any other.
>> >
>> > The majority of machines running Linux most likely runs with ARM CPUs.
>> >
>> > Show me any public source you want to use for getting serious data for
>> > this area.
>>
>> There is no one, except dispersed reports and ... appropriate
>> implementation involving search engine comes to mind.
>
> Much of this information will never be published at any place where
> Google could find it.

But Adrian, there will be a chain reaction. That's why Andrew
encourages interested parties from industry share code (which will
mean bug reports). This is gradual process, way of collaboration and
open source is being more and more accepted and even urged.
>
>> >> So the answer
>> >> to question about kernel stability would be more adequate depending on
>> >> who's asking.
>> >
>> > You must not confuse "number of reported bugs" with "kernel stability" -
>> > these two can be quite decoupled.
>>
>> Number of existing, proven and prioritized  bugs maybe better to say.
>> I think there is a correlation.
>
> Some correlaton.
>
> If people are aware of the weaknesses and the many obvious ways to
> manipulate such statistics.

... which needs to start and take its own development cycle. Then it
will become more sophisticated.
>
>> --Natalie
>
> cu
> Adrian
>
> --
>
>       "Is there not promise of rain?" Ling Tan asked suddenly out
>        of the darkness. There had been need of rain for many days.
>       "Only a promise," Lao Er said.
>                                       Pearl S. Buck - Dragon Seed
>
>
