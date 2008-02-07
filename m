Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYBGKPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYBGKPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYBGKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:15:35 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:57387 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbYBGKPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:15:34 -0500
Subject: Re: [PATCH/HP6XX] - Add leds support to the HP Jornada 6xx handheld
From: Richard Purdie <rpurdie@openedhand.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <20080205191356.ae2e8948.Kristoffer.ericson@gmail.com>
References: <20080205191356.ae2e8948.Kristoffer.ericson@gmail.com>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 10:15:31 +0000
Message-Id: <1202379331.9519.14.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 19:13 +0100, Kristoffer Ericson wrote:
> Richard, I've been told from paul that I should seek another solution
> for my hd6446x.h merger (perhaps mfd driver). So this patch
> is against linux-2.6.git with the header and defines changed back to
> old style. Tested to compile. I tested the "old" patch and that worked
> and I've only changed 5-6 names so it really should work as before.

I've added this to the LED tree with a couple of tweaks to the Kconfig
entry.

Cheers,

Richard

