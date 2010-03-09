Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0CIR7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:59:22 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:52137 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab0CIR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:59:20 -0500
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 12:59:19 EST
MIME-Version: 1.0
In-Reply-To: <20100309175229.c231f088.kristoffer.ericson@gmail.com>
References: <1268148843-13135-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> 
	<20100309175229.c231f088.kristoffer.ericson@gmail.com>
From: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Tue, 9 Mar 2010 14:37:09 -0300
Message-ID: <cecb6d8f1003090937t4ec3fe1cw293be3735caa2648@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-sa1100: Put nanoEngine support back in the 
	kernel.
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux@arm.linux.org.uk, mad_soft@inbox.ru, rpjday@crashcourse.ca,
       jaswinderrajput@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristoffer,

On Tue, Mar 9, 2010 at 13:52, Kristoffer Ericson
<kristoffer.ericson@gmail.com> wrote:
>
> Without testing it on the actual hardware it applies and looks good, compilation also goes smoothly without any issues.
> It looks quite alright to me. What are you planning to do with the fixup function?

Sorry, this function was the first things I wrote, but the kernel 2.6
infrastructure made it totally unnecessary and it should have been
removed. I will do it and send another patch.

> Im just missing the licensing text in the nano...c file for future reference,

Ok, I will add it too.

> after that feel free to add:
> Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
>
> Best wishes
> Kristoffer

Regards,
Marcelo.
