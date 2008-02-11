Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYBKLWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYBKLWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYBKLW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:22:26 -0500
Received: from sacred.ru ([62.205.161.221]:52258 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYBKLWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:22:25 -0500
Message-ID: <47B02FF3.80309@openvz.org>
Date: Mon, 11 Feb 2008 14:22:27 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Duncan Sands <baldrick.bulk@free.fr>
CC: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][USBATM]: convert heavy init dances to kthread API
References: <47A9DD30.5040604@openvz.org> <200802071057.41201.baldrick.bulk@free.fr> <47AAD886.2000606@openvz.org> <200802102130.45196.baldrick.bulk@free.fr>
In-Reply-To: <200802102130.45196.baldrick.bulk@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 11 Feb 2008 14:22:15 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duncan Sands wrote:
> Hi Pavel,
> 
>> Oh, I see. You're right - this race is possible... I'll fix that up
>> if this patch works.
> 
> it seems to work fine.  Thanks again for doing this!

Oh, thanks for testing. What should I do next to get this into
mainline? Send it to Andrew with you in Cc, or you have you own
tree for merging?

> Best wishes,
> 
> Duncan.
> 

Thanks,
Pavel
