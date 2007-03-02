Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXCBC2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXCBC2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422788AbXCBC2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:28:12 -0500
Received: from ipmail02.adl2.internode.on.net ([203.16.214.141]:30112 "EHLO
	ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422786AbXCBC2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:28:11 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 21:28:10 EST
X-IronPort-AV: i="4.14,239,1170595800"; 
   d="scan'208"; a="91816599:sNHT4244647652"
Message-ID: <45E78A20.2030007@iinet.net.au>
Date: Fri, 02 Mar 2007 13:21:20 +1100
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Dmitry Torokhov <dtor@mail.ru>, pHilipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.21-rc2] gpio_keys driver shouldn't be ARM-specific
References: <200703011551.29696.david-b@pacbell.net> <45E76D65.30405@iinet.net.au> <200703011654.18682.david-b@pacbell.net>
In-Reply-To: <200703011654.18682.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> With the || AVR32 I've added to my version it's getting a bit out of 
>> hand!  Anyone else think it would be worth introducing a GPIO_FRAMEWORK 
>> symbol selected by each machine which supports it and just set the 
>> gpio_keys dependency to that?
> 
> Earlier today I posted a patch adding CONFIG_GENERIC_GPIO, and
> I think that will get merged soonish ...
> 
Beat me to it again.  Cheers,
--Ben.
> - Dave
> 
