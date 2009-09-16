Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbZIPWDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbZIPWDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZIPWDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:03:39 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:44539 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752524AbZIPWDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:03:39 -0400
Date: Wed, 16 Sep 2009 23:50:53 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: add AC97 support to at91sam9rl and at91sam9rlek
 board
Message-ID: <20090916215053.GE4172@game.jcrosoft.org>
References: <1253122902-15647-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253122902-15647-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6983957123079121772
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:41 Wed 16 Sep     , Nicolas Ferre wrote:
> Add the support of AC97 on the at91sam9rl chip and -ek board.
> It will share the code with AVR32 ac97c alsa driver "atmel_ac97c".
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91sam9rl_devices.c |   55 +++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/board-sam9rlek.c     |   10 ++++++
>  2 files changed, 65 insertions(+), 0 deletions(-)
Looks fine

Best Regards,
J.
