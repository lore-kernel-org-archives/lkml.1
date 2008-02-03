Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYBCWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYBCWh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYBCWhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:37:16 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:52398 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbYBCWhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:37:14 -0500
X-Greylist: delayed 1755 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2008 17:37:14 EST
Subject: Re: [PATCH/LEDS] - Add support for leds on the HP Jornada 6xx
	series
From: Richard Purdie <rpurdie@openedhand.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
In-Reply-To: <20080203214615.5cff3eef.Kristoffer.ericson@gmail.com>
References: <20080203214615.5cff3eef.Kristoffer.ericson@gmail.com>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 22:07:55 +0000
Message-Id: <1202076475.4596.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-03 at 21:46 +0100, Kristoffer Ericson wrote:
> shortlog:
> The HP Jornada 6xx series have simple leds thats able to produce green or red light.
> This patch enables the leds to be used by the kernel and/or userland.
> 
> signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> 
> Richard please note that this driver makes use of
> include/asm-sh/hd6446x.h which is a merged header not yet
> available. I've sent patch to paul but gotten no answer yet. If you
> cannot commit it for that reason, then please just look through it.

It shouldn't really go in until thats been merged. I couldn't see
anything wrong with the driver so just let me know when that header has
merged...

Cheers,

Richard



