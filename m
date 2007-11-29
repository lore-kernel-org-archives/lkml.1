Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbXK2BTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbXK2BTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760694AbXK2BTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:19:40 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:9980 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940AbXK2BTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:19:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wH7rnmiby9ylhmfNNjHNGwJGZ+XdcfYNzJKX01BnREhgypoaVSESuW6iVZbrK7dwmQ7t/Y1g0/P8/ckoPiaiyO8nf9pbQlMp7sj0FNJY47qhbhYHKYGcU1tUCZrN1lIGoPTq6UXJFO+y14HER9rNl8TC+5K5fhJONudTzDAFFfY=
Message-ID: <d82e647a0711281719s74035e98pc228ce0da4f3b00d@mail.gmail.com>
Date: Thu, 29 Nov 2007 09:19:36 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: void* arithmnetic
Cc: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711290130170.22052@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20071129010531.22b3a71f@werewolf>
	 <Pine.LNX.4.64.0711290130170.22052@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/29, Jan Engelhardt <jengelh@computergmbh.de>:
>
> On Nov 29 2007 01:05, J.A. Magallón wrote:
> >
> >Since begin of the ages the build of the nvidia driver says things like
> >this:
> >
>
> Explicitly adding -Wpointer-arith to ones own Makefile is like
> admitting the code might be problematic. :->
>
>
> I think sizeof(void *) == 1 is taken as granted as sizeof(int) >= 4
> these days. Sigh.
sizeof(void *) == 4, sizeof(void)==1, :)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
