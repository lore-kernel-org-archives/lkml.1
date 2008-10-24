Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYJXRg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYJXRg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYJXRgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:36:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYJXRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:36:49 -0400
Date: Fri, 24 Oct 2008 15:36:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
Subject: Re: [PATCH 3/7] adding xc5000 tuner chip driver
Message-ID: <20081024153635.749b1b59@pedra.chehab.org>
In-Reply-To: <d9def9db0810221405p40cd3b7v8e4adc011a292eb9@mail.gmail.com>
References: <d9def9db0810221405p40cd3b7v8e4adc011a292eb9@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 23:05:39 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

>     xc5000_module.c:
>     linuxtv tuner frontend interface
>     xc5000_control.c:
>     core xceive tuning code
> 
>     this code also uses the tunerchip.h interface which allows to attach
>     the whole driver only once and reuse it as often as needed using a generic
>     interface.
>     It uses the latest Xceive reference driver which fixes some issues.

NACK. There's already a driver for XC5000 on kernel.



Cheers,
Mauro
