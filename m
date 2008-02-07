Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbYBGPNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbYBGPNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbYBGPNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:13:42 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34907 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbYBGPNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:13:41 -0500
Message-ID: <47AB2022.7080303@davidnewall.com>
Date: Fri, 08 Feb 2008 01:43:38 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Diego Zuccato <diego@otello.alma.unibo.it>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>            <20080202123710.42df1aa0@weinigel.se>            <20080202191930.GA19826@kroah.com>            <47A5D895.20300@davidnewall.com>            <47A6E742.80408@otello.alma.unibo.it> <courier.47A8F072.000079E4@hawking.rebel.net.au> <47AAC1EE.6060101@otello.alma.unibo.it> <47AB0911.3060508@davidnewall.com> <47AB14E4.6080100@otello.alma.unibo.it>
In-Reply-To: <47AB14E4.6080100@otello.alma.unibo.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Zuccato wrote:
> David Newall ha scritto:
>
>> That's naive, since requirements differ in different jurisdictions, as
>> I'm sure you are perfectly aware.
> Naive? Who thinks a limit can be enforced by sw is naive!

Of course.  Naturally it's near impossible to prevent people from
tweaking the software.  But reasonable restrictions are what regulatory
bodies expect.

> Precisely: One purpose of the driver is to enforce local compliance.
> It can't *enforce* it anyway, at least if the users are all around the
> world.

Yes it can.   You're confusing the software with different or modified
software.  Different things.  And by the way, if you modify the software
to defeat the restrictions you are committing a criminal act, or you
would be if you did it in Australia.  You'd probably get with
crucifixion for a first offense!

>>> But linear amplifiers are commonly sold. And (at least in Italy) it's
>>> not illegal to buy one, even if it can boost antenna power to 1000W.
>>> It's illegal just to USE it.
>> In Australia it's illegal to own them (CB licensee; HAMs are allowed to
>> use them, although not on 27Mhz.)
> Then Australian shops can ask for the licence. And what about online
> shops? Ebay? They'll send you an unmarked package (same as letting you
> download another country's driver). The result is that you can have
> your LA more easyly than going to a local shop or tampering with your
> CB (or tampering whith the local version of the driver).

What's your point?  That it's easy to break the law?  Nobody's arguing
against that.


>>> And it's a logical problem, too: why should the *driver* enforce a
>>> *technical* limit?
>> That's part of it's purpose.  It permits a manufacturer to make a global
>> device that operates within local restrictions.
> Nope. The driver should simply make the device WORK. The USER must
> make sure to meet the local regulations.

Definitely no.  The manufacturer must ensure it meets local
regulations.  One way they do that is via the driver.


> The driver can help, but as long as it asks the user a country
> setting, its enforcement is nearly nothing!

You're correct, but that's still how it is.  In fact, some manufacturers
provide country specific drivers simply to shore up this weakness. 
(They'd only do that to protect their regulatory approval.)

> Another example. Think about what happens if you're right: the user
> gets caught with a WiFi card operating on an illegal channel, but the
> system appears correctly configured (location-wise). When analyzed, it
> turns out that, due to a bug in the driver, the card uses that channel
> (for example 13) because the user only changed the country setting
> when flying back from Japan (where he used channel 13) and channel
> limiter didn't kick in. Is the manufacturer responsible?
Are you asking if the manufacturer could lose their licence to sell the
product?  It could happen.  Regulators do wield significant powers.

> If you're right, he is and must pay, remove that device from shops and
> replace sold ones. Or at least make sure all users update their
> drivers with others without that bug... 
That's the most likely result.  That would be what I expect would
happen.  This is why manufacturers view open source licences dimly in
certain markets, of which radio communications is just one example.
