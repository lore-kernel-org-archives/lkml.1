Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZIULys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZIULys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZIULyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:54:44 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:47076 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751779AbZIULyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:54:43 -0400
Date: Mon, 21 Sep 2009 13:41:12 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       haavard.skinnemoen@atmel.com, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: at91sam9g45 family: identify several chip
 versions
Message-ID: <20090921114112.GR29905@game.jcrosoft.org>
References: <1253529601-15474-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253529601-15474-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7619809095675194220
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:40 Mon 21 Sep     , Nicolas Ferre wrote:
> cpu_is_xxx() macros are identifying generic at91sam9g45 chip. This patch adds
> the capacity to differentiate Engineering Samples and final lots through the
> inclusion of  at91_cpu_fully_identify() and the related chip IDs with chip
> version field preserved.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/include/mach/cpu.h     |    9 +++++++++
>  arch/avr32/mach-at32ap/include/mach/cpu.h |    1 +
>  2 files changed, 10 insertions(+), 0 deletions(-)
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
