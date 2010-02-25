Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab0BYBqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:46:53 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:25690 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760Ab0BYBqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:46:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lMYA0fghQjzp+/O1Z5U5Fhbft6St/jL9Qq6zB4UaD0ShPJg/25CxkeEc4f2tB9RDvF
         hhDfQ9bjUAm1J2M5RRVzbNH+POl5o5xaSjUMRw4j4bJLQJ9vRUfHOL2qivEqZoq9ntjC
         IG+A0mKUakiDR1Ev6nVsRIGjAVn0BePEmeptw=
MIME-Version: 1.0
In-Reply-To: <20100224132414.GB21421@kroah.com>
References: <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <1266678496.32309.1.camel@jlt3.sipsolutions.net>
	 <20100220152010.GI3000@hack>
	 <1266679687.17363.1.camel@jlt3.sipsolutions.net>
	 <20100220154049.GM3000@hack>
	 <1266680582.17363.7.camel@jlt3.sipsolutions.net>
	 <1266979753.23523.1670.camel@pasglop>
	 <1266996757.3903.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002232334p219f4ebem6006172153e7a3f1@mail.gmail.com>
	 <20100224132414.GB21421@kroah.com>
Date: Thu, 25 Feb 2010 09:46:45 +0800
Message-ID: <2375c9f91002241746j19930fdkf8273fdabfae8362@mail.gmail.com>
Subject: Re: [PATCH] windfarm: init sysfs attributes
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 9:24 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Feb 24, 2010 at 03:34:52PM +0800, Am??rico Wang wrote:
>> On Wed, Feb 24, 2010 at 3:32 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2010-02-24 at 13:49 +1100, Benjamin Herrenschmidt wrote:
>> >> On Sat, 2010-02-20 at 16:43 +0100, Johannes Berg wrote:
>> >> > This is required for lockdep.
>> >>
>> >> Please CC linuxppc-dev@ozlabs.org or it doesn't get caught by
>> >> patchwork.
>> >
>> > Eh, sure, but I think it needs to be part of Eric's series?
>> >
>>
>> Yeah, that's why we are Cc'ing Greg, since he took Eric's patches already.
>>
>> Greg?
>
> I didn't take all of them yet, that will happen later today, and I'll
> also queue this up, as it is then required.

Thanks, also this one:

http://lkml.org/lkml/2010/2/20/119
