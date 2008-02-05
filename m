Return-Path: <linux-kernel-owner+w=401wt.eu-S1762649AbYBEXZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649AbYBEXZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbYBEXZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:25:41 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34381 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYBEXZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:25:40 -0500
References: <20080125180232.GA4613@kroah.com>
            <20080202123710.42df1aa0@weinigel.se>
            <20080202191930.GA19826@kroah.com>
            <47A5D895.20300@davidnewall.com>
            <47A6E742.80408@otello.alma.unibo.it>
In-Reply-To: <47A6E742.80408@otello.alma.unibo.it>
From: David Newall <davidn@davidnewall.com>
To: Diego Zuccato <diego@otello.alma.unibo.it>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Wed, 06 Feb 2008 09:55:38 +1030
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <courier.47A8F072.000079E4@hawking.rebel.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Zuccato writes:
> David Newall ha scritto:
>> This does, of course,
>> disadvantage Linux with respect to many classes of devices, for example
>> GSM transceivers when used in those parts of the world^ where regulatory
>> requirements prohibit modification of power or frequency settings, which
>> effectively prohibits open-source driver.
>
> Why "of course" ?
 

"Of course", because in many parts of the world, a device who's manufacturer 
fails to take reasonable steps to prevent it from being used outside 
regulatory limits is illegal.  Providing source code not only is a failure 
to take those reasonable steps, but is quite the opposite.  It may even be 
viewed as encouraging users to use it inappropriately.
