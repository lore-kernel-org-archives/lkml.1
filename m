Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYA1ILf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYA1ILf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYA1IL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:11:28 -0500
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:37742 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYA1IL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:11:27 -0500
Message-ID: <479D8E9C.5030808@ladisch.de>
Date: Mon, 28 Jan 2008 09:13:16 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>
In-Reply-To: <20080125180232.GA4613@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: 006495
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Over two years ago, the Linux USB developers stated that they believed
> there was no way to create a USB kernel driver that was not under the
> GPL.  This patch moves the USB apis to enforce that decision.
>
> There are no known closed source USB drivers in the wild, so this patch
> should cause no problems.

There are the commercial OpenSound drivers.


Regards,
Clemens
