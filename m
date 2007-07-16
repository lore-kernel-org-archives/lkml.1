Return-Path: <linux-kernel-owner+w=401wt.eu-S1764601AbXGPNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764601AbXGPNnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXGPNnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:43:10 -0400
Received: from wp020.webpack.hosteurope.de ([80.237.132.27]:56227 "EHLO
	wp020.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbXGPNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:43:09 -0400
X-Greylist: delayed 1837 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 09:43:09 EDT
Message-ID: <469B6EB1.1060201@arcor.de>
Date: Mon, 16 Jul 2007 15:12:17 +0200
From: Klaus Fuerstberger <kfuerstberger@arcor.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.0.12) Gecko/20070510 Iceape/1.0.9 (Debian-1.0.9-0etch1)
MIME-Version: 1.0
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
CC: Tejun Heo <htejun@gmail.com>, Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu> <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local> <Pine.LNX.4.64.0707161327470.4941@kai.makisara.local> <469B54DE.5090703@gmail.com> <Pine.LNX.4.64.0707161453230.5065@kai.makisara.local>
In-Reply-To: <Pine.LNX.4.64.0707161453230.5065@kai.makisara.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;kfuerstberger@arcor.de;1184593389;c0761143;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Makisara said the following on 16.07.2007 13:58:

>> Please try the patch in the following message.
>> http://article.gmane.org/gmane.linux.ide/20799/raw

> This solves the 'smartctl -H' problem both of my systems (one with Nvidia 
> CK804 and one with MCP51).

This patch also solved the problem I reported here:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=428975

Thanks!

Bye Klaus
