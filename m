Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbXGPLWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbXGPLWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbXGPLWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:22:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:3436 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbXGPLWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AMlxb7gG3NJ3PmC3akaGCeLe1sHeRr/82gTR7gshAn9yxPGEwt48DvIyuL4Ln0G7kxH3WVXDQQ3bkvFUmala5VFiF+APf4Y9jgXHoRQ1BNET8B/Jkl+Y3f5gSXlgxtz8RSQMmsl4XQSSO78SHet8Cr6fX1LtN5eKCH1VOPJd28s=
Message-ID: <469B54DE.5090703@gmail.com>
Date: Mon, 16 Jul 2007 20:22:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
CC: Bruce Allen <ballen@gravity.phys.uwm.edu>, Mark Lord <liml@rtr.ca>,
       David Greaves <david@dgreaves.com>, Douglas Gilbert <dougg@torque.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu> <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local> <Pine.LNX.4.64.0707161327470.4941@kai.makisara.local>
In-Reply-To: <Pine.LNX.4.64.0707161327470.4941@kai.makisara.local>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please try the patch in the following message.

http://article.gmane.org/gmane.linux.ide/20799/raw

-- 
tejun
