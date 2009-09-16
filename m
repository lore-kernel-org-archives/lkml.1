Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbZIPWDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbZIPWDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZIPWDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:03:49 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:34288 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752524AbZIPWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:03:48 -0400
Date: Wed, 16 Sep 2009 23:51:03 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: add AC97 support to at91sam9g45 series and
 at91sam9m10g45ek board
Message-ID: <20090916215103.GF4172@game.jcrosoft.org>
References: <1253122902-15647-1-git-send-email-nicolas.ferre@atmel.com>
 <1253122902-15647-2-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253122902-15647-2-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6986771872859401068
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:41 Wed 16 Sep     , Nicolas Ferre wrote:
> Add the support of AC97 on the at91sam9g45 chip series and -ek board.
> It will share the code with AVR32 ac97c alsa driver "atmel_ac97c".
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c |   55 ++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/board-sam9m10g45ek.c  |   10 +++++
>  2 files changed, 65 insertions(+), 0 deletions(-)
Looks fine

Best Regards,
J.
