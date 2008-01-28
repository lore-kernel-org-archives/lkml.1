Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYA1J5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYA1J5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYA1J5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:57:05 -0500
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:42295 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYA1J5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:57:04 -0500
Message-ID: <479DA75F.2070603@ladisch.de>
Date: Mon, 28 Jan 2008 10:58:55 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <479D8E9C.5030808@ladisch.de> <20080128085757.GA25035@kroah.com>
In-Reply-To: <20080128085757.GA25035@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: 006495
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 28, 2008 at 09:13:16AM +0100, Clemens Ladisch wrote:
>> Greg KH wrote:
>> > Over two years ago, the Linux USB developers stated that they believed
>> > there was no way to create a USB kernel driver that was not under the
>> > GPL.  This patch moves the USB apis to enforce that decision.
>> >
>> > There are no known closed source USB drivers in the wild, so this patch
>> > should cause no problems.
>>
>> There are the commercial OpenSound drivers.
>
> What are they?  Do you have a link to them?

http://www.opensound.com/

> And why have I not heard from any user of them for the past two years
> (we have had a kernel warning for over 2 years for this issue.)

They aren't used widely (with Linux), and AFAIK the USB driver doesn't
have anything to favor it over the ALSA driver.


As far as my (biased) opinion is of interest, I'm not objecting against
your patch.


Regards,
Clemens
