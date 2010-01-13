Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381Ab0AMGdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0AMGdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085Ab0AMGdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:33:18 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:36571 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0AMGdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:33:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=drddgn+Ljo6X3jIPuu1eAgtbkUWrWBL6QvylKWUrVTzfodf6deQUgrEaaJFZI2e8vU
         lz+TP3nVyLwYTIJ9u3WhbiUD9IXwr3h8OPG7oP0MpOLtGpeY3OdFqYTCEYG2SuKDoLPI
         CEhdAcngrQqwSNl2ESrl2tbIhfyWIKOqR1B6U=
MIME-Version: 1.0
In-Reply-To: <1263019425.20926.12.camel@Joe-Laptop.home>
References: <1263019425.20926.12.camel@Joe-Laptop.home>
Date: Wed, 13 Jan 2010 08:33:15 +0200
Message-ID: <cd73a99e1001122233x79ab52dbl4b824fbe6b424566@mail.gmail.com>
Subject: Re: [PATCH] arch/arm: Remove unnecessary semicolons
From: Andrew Victor <avictor.za@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Sascha Hauer <kernel@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Joe,

>  arch/arm/mach-at91/at91cap9_devices.c    |    2 +-
>  arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
>  arch/arm/mach-at91/at91sam9rl_devices.c  |    2 +-

For the AT91-changes,
  Acked-by: Andrew Victor <linux@maxim.org.za>
