Return-Path: <linux-kernel-owner+w=401wt.eu-S1031178AbXD1NAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031178AbXD1NAT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031160AbXD1NAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:00:18 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:40488 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030634AbXD1NAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:00:01 -0400
Message-ID: <463345B1.1070600@ru.mvista.com>
Date: Sat, 28 Apr 2007 17:01:37 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Mattie <codermattie@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: htpt366 PCI latency value is really high
References: <20070426064927.13d0ed72@reforged>	<4630B789.3040402@ru.mvista.com>	<20070427230950.33d4d040@reforged> <20070428104811.574de77b@the-village.bc.nu>
In-Reply-To: <20070428104811.574de77b@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>There are many reasons a card would default to a higher level, but in
>>the end it is basically tuning the card for a server application.

>>A warning that some cards default to high PCI latency values; settings that 
>>can interfere with latency sensitive devices such as sounds cards - this 
>>could be a help to others.  

> A warning that there are quite a few cards that subtly corrupt your data
> if you don't have the latency set to values to work around chip errata is
> also worth making.

> You fiddle with PCI latency values at your peril, and preferably with the
> data sheet and errata docs to hand.

   And I don't have the latter for the HighPoint chips. Not sure if anybody ever had it. :-)

> Alan

MBR, Sergei
