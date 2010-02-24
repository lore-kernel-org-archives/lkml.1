Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0BXHey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:34:54 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:14137 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0BXHex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VeULnncD8N6fzZNotmff4EhODFVzvR/jc3eIgKbkjH0+1CcuzYwcLDLsE1cqPEIPj7
         1X/pmP2Gf4tRB1k3DvjpH77kw/+P7u0ZR4OphWH+KD/FJt4KTO7E3+ffBsTrm9YANd7h
         TqvIMNPRxGSuI0vHmrDBBsU+BJdAyTweLi8v4=
MIME-Version: 1.0
In-Reply-To: <1266996757.3903.0.camel@jlt3.sipsolutions.net>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <20100220150327.GG3000@hack>
	 <1266678496.32309.1.camel@jlt3.sipsolutions.net>
	 <20100220152010.GI3000@hack>
	 <1266679687.17363.1.camel@jlt3.sipsolutions.net>
	 <20100220154049.GM3000@hack>
	 <1266680582.17363.7.camel@jlt3.sipsolutions.net>
	 <1266979753.23523.1670.camel@pasglop>
	 <1266996757.3903.0.camel@jlt3.sipsolutions.net>
Date: Wed, 24 Feb 2010 15:34:52 +0800
Message-ID: <2375c9f91002232334p219f4ebem6006172153e7a3f1@mail.gmail.com>
Subject: Re: [PATCH] windfarm: init sysfs attributes
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 3:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-02-24 at 13:49 +1100, Benjamin Herrenschmidt wrote:
>> On Sat, 2010-02-20 at 16:43 +0100, Johannes Berg wrote:
>> > This is required for lockdep.
>>
>> Please CC linuxppc-dev@ozlabs.org or it doesn't get caught by
>> patchwork.
>
> Eh, sure, but I think it needs to be part of Eric's series?
>

Yeah, that's why we are Cc'ing Greg, since he took Eric's patches already.

Greg?
