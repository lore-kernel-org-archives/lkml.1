Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZJRK5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZJRK5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 06:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZJRK5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 06:57:11 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:62249 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZJRK5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 06:57:11 -0400
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
From: Richard Purdie <rpurdie@rpsys.net>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Constantin Baranov <const@mimas.ru>
In-Reply-To: <20091016130315.GT28832@buzzloop.caiaq.de>
References: <20091016130315.GT28832@buzzloop.caiaq.de>
Content-Type: text/plain
Date: Sun, 18 Oct 2009 11:56:52 +0100
Message-Id: <1255863412.27878.136.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2009-10-16 at 15:03 +0200, Daniel Mack wrote:
> for a project I was working on, we used the J15 connector of the ALIX.2D
> board (which is connected to a GPIO of the CS5536 Geode companion chip)
> for an external button switch.
> 
> I thought it might be worth sharing this piece of code, so others can do
> the same.
> 
> There is, however, a small hardware modification is necessary as the pin
> is also shared as buzzer output. I noted that in the Kconfig entry.
> 
> The patch should go thru Richard's led-2.6.git as it depends on another
> one that has been queued there already.

How common is this modification? I'm just trying to get a feel for the
number of users out there of this feature...

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

