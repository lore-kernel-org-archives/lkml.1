Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbYFGPfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbYFGPfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbYFGPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:35:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:19761 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYFGPfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tT2bpC3M6aUqH3mHfmROjMtmVk8YfSUgQXMb3pb27AhXUurnol5VwOD54WvAyorsAe
         gReYouPKVKErIl23+rywhNIF8WbnXqXGsjLIDokuJtgo0snHR0CTB90m2dkLzVp30UOB
         aEHJwm3Zy0N8gOKzOYBgN9U+5Ye7QF1mUu2os=
Message-ID: <cd73a99e0806070835g2d0f4ab8i9fbb49a654575972@mail.gmail.com>
Date: Sat, 7 Jun 2008 17:35:18 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Patrice Vilchez" <patrice.vilchez@atmel.com>,
       "Russell King" <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] Fix NAND FLASH timings for at91sam9x evaluation kits.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48493D16.1050503@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48493D16.1050503@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Patrice,

> Fix NAND FLASH timings for at91sam9x evaluation kits.
>
> New timings are based on application note
> "NAND Flash Support on AT91SAM9 Microcontrollers" available at
> http://atmel.com/dyn/resources/prod_documents/doc6255.pdf).
>
> Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>


> This timings are mandatory for newer kernel revision.
> Please, could you consider them before 2.6.26 final release.

Please submit to RMK's patch system.


Regards,
  Andrew Victor
