Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbXGASzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbXGASzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 14:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbXGASzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 14:55:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:43994 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755264AbXGASzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 14:55:04 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1+VQYJQUgOVOVueiJrHiaikWWklRfsJB1/1QWidt7
	lKhYsF1GRPAkEM
Message-ID: <4687F883.1000007@gmx.de>
Date: Sun, 01 Jul 2007 20:54:59 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Markus Rechberger <mrechberger@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>
Subject: Re: 2.6.22-rc6 spurious hangs
References: <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de> <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu> <20070629135848.GA332@tv-sign.ru> <1183152090.7089.183.camel@gaivota> <d9def9db0706291434v2fe69578qf84488bfd6a965f3@mail.gmail.com> <20070630141928.GA5182@tv-sign.ru>
In-Reply-To: <20070630141928.GA5182@tv-sign.ru>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Thomas, any chance you could try the patch below? It is very, very stupid,
> it was done without any understanding of this code, and of course it is
> completely untested. I doubt very much it is correct, and even if it is
> correct it is definitely not good. It would be great if Dmitry can take a look.

I'm still testing but I couldn't break it until now.
And I didn't find any drawbacks yet.

Thomas

-- 
keep mailinglists in english, feel free to send PM in german
