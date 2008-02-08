Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbYBHIs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbYBHIs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761676AbYBHIsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:48:17 -0500
Received: from otello.alma.unibo.it ([137.204.24.163]:56238 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310AbYBHIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:48:15 -0500
Message-ID: <47AC174C.4080300@otello.alma.unibo.it>
Date: Fri, 08 Feb 2008 09:48:12 +0100
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.9 (X11/20080206)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>            <20080202123710.42df1aa0@weinigel.se>            <20080202191930.GA19826@kroah.com>            <47A5D895.20300@davidnewall.com>            <47A6E742.80408@otello.alma.unibo.it> <courier.47A8F072.000079E4@hawking.rebel.net.au> <47AAC1EE.6060101@otello.alma.unibo.it> <47AB0911.3060508@davidnewall.com> <47AB14E4.6080100@otello.alma.unibo.it> <47AB2022.7080303@davidnewall.com>
In-Reply-To: <47AB2022.7080303@davidnewall.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall ha scritto:

>> Precisely: One purpose of the driver is to enforce local compliance.
>> It can't *enforce* it anyway, at least if the users are all around the
>> world.
> Yes it can.   You're confusing the software with different or modified
> software.  Different things.  And by the way, if you modify the software
> to defeat the restrictions you are committing a criminal act, or you
> would be if you did it in Australia.
You said it! Gotcha! :-)
There's no difference if what I'm going to modify is the binary or the 
source: it's a criminal act anyway.
So why not release the source? :-)
>  You'd probably get with
> crucifixion for a first offense!
ROFLASTC :-)

> What's your point?  That it's easy to break the law?  Nobody's arguing
> against that.
I was simply implying there are easier ways than others... And binary 
drivers can't help...

>> Nope. The driver should simply make the device WORK. The USER must
>> make sure to meet the local regulations.
> Definitely no.  The manufacturer must ensure it meets local
> regulations.  One way they do that is via the driver.
Well, the driver must trust the user, that's my point.
If the user lies, the driver can't know (well, it could, but I don't 
think it could be considered "reasonable"...).

> You're correct, but that's still how it is.  In fact, some manufacturers
> provide country specific drivers simply to shore up this weakness. 
> (They'd only do that to protect their regulatory approval.)
Allowing the lying user to download a driver for another country...

>> If you're right, he is and must pay, remove that device from shops and
>> replace sold ones. Or at least make sure all users update their
>> drivers with others without that bug... 
> That's the most likely result.  That would be what I expect would
> happen.  This is why manufacturers view open source licences dimly in
> certain markets, of which radio communications is just one example.
And it's a reason to release open drivers, so that everybody can check 
there's no such bug. And, if found, it can be fixed with a lot less effort.

BTW I've now asked a lawyer... Waiting his answer.

BYtE,
  Diego.
