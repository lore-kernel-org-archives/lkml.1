Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbXJAHfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbXJAHfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXJAHfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:35:10 -0400
Received: from tim.rpsys.net ([194.106.48.114]:45140 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXJAHfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:35:09 -0400
Subject: Re: What's in linux-leds.git for 2.6.24?
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1191196330.6115.49.camel@localhost.localdomain>
References: <1191196330.6115.49.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 08:34:57 +0100
Message-Id: <1191224097.5938.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 00:52 +0100, Richard Purdie wrote:
> The leds tree doesn't have much in it, basically some changes to the
> cobalt LED drivers.
> 
> http://git.o-hand.com/?p=linux-rpurdie-leds;a=shortlog;h=for-mm
> 
> Yoichi Yuasa (3):
>       leds: Rename leds-cobalt driver
>       leds: Add Cobalt Raq series LEDs support
>       leds: Update Cobalt Qube series front LED support

The missing diffstat:

 drivers/leds/Kconfig            |   13 ++-
 drivers/leds/Makefile           |    3 
 drivers/leds/leds-cobalt-qube.c |  102 +++++++++++++++++++++++++++++
 drivers/leds/leds-cobalt-raq.c  |  138 ++++++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-cobalt.c      |   43 ------------
 5 files changed, 252 insertions(+), 47 deletions(-)

-- 
Richard

