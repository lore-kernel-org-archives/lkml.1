Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXFGOMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXFGOMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXFGOMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:12:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53501 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961AbXFGOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:12:33 -0400
Subject: Re: [v4l-dvb-maintainer] drivers/media/dvb/b2c2/flexcop-dma.c uses
	PCI DMA API
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <46681040.2010003@linuxtv.org>
References: <Pine.LNX.4.64.0706062106150.30244@anakin>
	 <1181220656.4187.64.camel@gaivota>  <46681040.2010003@linuxtv.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 11:10:52 -0300
Message-Id: <1181225452.4187.111.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Mauro,
> 
> It appears that your change has caused the following build warning:
> 
> WARNING: "b2c2_flexcop_debug"
> [/home/mk/v4l-dvb-master/v4l/b2c2-flexcop-pci.ko] undefined!

Weird, this error didn't appeared on my tests here.  

Ok, I'll work on fixing this. 

I have another alternative working only on Kconfig stuff, but this seems
to be the cleaner one.

-- 
Cheers,
Mauro

