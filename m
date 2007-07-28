Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXG1N5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXG1N5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 09:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXG1N5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 09:57:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58582 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXG1N5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 09:57:01 -0400
Date: Sat, 28 Jul 2007 15:57:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: zd1211b question.
In-Reply-To: <200707280755.34930.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.64.0707281556360.15125@fbirervta.pbzchgretzou.qr>
References: <200707280755.34930.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 28 2007 07:55, Gene Heskett wrote:
>Greetings all;
>
>A net friend of mine has a Gateway m305CRV laptop, with this radio in it:
>Bus 003 Device 003: ID 050d:705c Belkin Components
>
>Its apparently sitting on the usb bus, and from my grepping of the kernel 
>srcs, it looks as if the zd1211b driver might be the correct one:
>[...]
>This last one is the right set of numbers.  However, I'll be dipped but I 
>can't find anyplace in a make xconfig in the 2.6.22.1-rt9 tree, to turn on 
>the building of that driver.
>
>Am I blind, don't know how to run grep, or does the xconfig script need more 
>tlc?
>
>Can somebody toss me a bone of info here?

cat drivers/net/wireless/zd1211rw/Kconfig?


	Jan
-- 
