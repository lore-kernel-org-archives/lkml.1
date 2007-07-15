Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXGOCJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXGOCJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 22:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761990AbXGOCJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 22:09:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47905 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761088AbXGOCJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 22:09:42 -0400
Message-ID: <469981E4.4040002@garzik.org>
Date: Sat, 14 Jul 2007 22:09:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Anton Vorontsov <cbou@mail.ru>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Power supply class and drivers: remove non obligatory
 return statements
References: <46996A53.6000807@garzik.org> <20070715014507.GB7474@zarina>
In-Reply-To: <20070715014507.GB7474@zarina>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> Per Jeff Garzik request.
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> ---
>  drivers/power/apm_power.c          |    4 ----
>  drivers/power/ds2760_battery.c     |    7 -------
>  drivers/power/olpc_battery.c       |    1 -
>  drivers/power/pda_power.c          |    5 -----
>  drivers/power/pmu_battery.c        |    2 --
>  drivers/power/power_supply_core.c  |    6 ------
>  drivers/power/power_supply_leds.c  |    8 --------
>  drivers/power/power_supply_sysfs.c |    2 --
>  drivers/w1/slaves/w1_ds2760.c      |    4 ----
>  9 files changed, 0 insertions(+), 39 deletions(-)

ACK, thanks


