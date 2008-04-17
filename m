Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYDQVCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYDQVCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYDQVCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:02:00 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:13386 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753719AbYDQVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HpICrzgancxrZ/8fRc2/zzU0LA6fpjyjDwyRB1qr2mgm9kMG4HxpwmN/3BfhIRgRbaZ6YPffdGUvoYK4CQWQNC3J2g9Nl9bBWy2GY/XNJubw2Jy69yxAmcu6YtVDlcCmBpZjTyoukY46Pc7+w9VEmOnOxynlPd7MQnv1oGfnglc=
Message-ID: <2c0942db0804171401r2696884bq22540deaab40ef9b@mail.gmail.com>
Date: Thu, 17 Apr 2008 14:01:55 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: Reporting bugs and bisection
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "David Newall" <davidn@davidnewall.com>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, sverre@rabbelier.nl,
       git@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "James Morris" <jmorris@namei.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Willy Tarreau" <w@1wt.eu>,
       david@lang.hm, "Stephen Clark" <sclark46@earthlink.net>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Tilman Schmidt" <tilman@imap.cc>, Valdis.Kletnieks@vt.edu,
       "Mark Lord" <lkml@rtr.ca>, "David Miller" <davem@davemloft.net>,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, netdev@vger.kernel.org
In-Reply-To: <20080417205301.GG27459@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FEADCB.7070104@rtr.ca>
	 <9a8748490804161417n4ad6c1den54ccd302831a66c6@mail.gmail.com>
	 <48078323.4010109@davidnewall.com> <200804172109.35027.rjw@sisk.pl>
	 <2c0942db0804171235o49238b99u6cdbd3e5c8d6ebb7@mail.gmail.com>
	 <20080417201657.GF27459@ZenIV.linux.org.uk>
	 <2c0942db0804171338p7bc7d9f2u8079c2f8c8998e76@mail.gmail.com>
	 <20080417205301.GG27459@ZenIV.linux.org.uk>
X-Google-Sender-Auth: de53ac6975b019b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 1:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Apr 17, 2008 at 01:38:18PM -0700, Ray Lee wrote:
>  > >         And frankly, that's the only thing that matters anyway; I suspect
>  > >  I'd do rather well by proposed criteria, but you know what?  I don't give
>  > >  a flying f*ck through the rolling doughnut for self-appointed PHBs and
>  > >  their idea of performance reviews.
>  >
>  > (Geez, conflate the issue much?) No one is saying you should. But
>  > also, I haven't seen anyone saying it'd be used for performance
>  > reviews other than you.
>
>
> || If there are individuals at whom a finger needs to be pointed, this
>  || system will highlight them, and fingers will (and should) be pointed.
>  || Contributors of poor-quality code need to be weeded-out.
>
>  in this thread (From: David Newall).

Ah, I failed reading comprehension, yet again. Well, sounds like you
have a beef to take up with David, then. That's still not an argument
against trying to gather statistics and to see if they're worth
anything.

>  > <shrug> Shame and Guilt, two major motivators of human behavior, it's
>  > true. But, one last time, *you're* the one saying the stats would be
>  > used for finger pointing at people.
>
>  Not really.  Unless you are trying to imply that David is my sock puppet, that
>  is...

Momentarily amusing to think so, but no :-).
