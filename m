Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZGDKEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZGDKEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZGDKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:04:19 -0400
Received: from d1.icnet.pl ([212.160.220.21]:36607 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315AbZGDKER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:04:17 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: felipe.balbi@nokia.com
Subject: Re: [PATCH] [RFC] OMAP1: AMS_DELTA: add modem support
Date: Sat, 4 Jul 2009 12:03:33 +0200
User-Agent: KMail/1.9.10
Cc: Jonathan McDowell <noodles@earth.li>, Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200907040206.42940.jkrzyszt@tis.icnet.pl> <20090704085721.GA29751@nokia.com>
In-Reply-To: <20090704085721.GA29751@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907041203.35130.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Saturday 04 July 2009 10:57:21 Felipe Balbi wrote:
> you should avoid OMAP_GPIO_IRQ() and use gpio_to_irq(), but for that

Thanks, I'll change that and resubmit.

Janusz
