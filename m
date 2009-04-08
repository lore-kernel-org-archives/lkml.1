Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbZDHKba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbZDHKba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZDHKbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:31:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46088
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761779AbZDHKbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:31:19 -0400
Date: Wed, 08 Apr 2009 03:31:08 -0700 (PDT)
Message-Id: <20090408.033108.141243098.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: yanghy@cn.fujitsu.com, mingo@elte.hu, chripell@gmail.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [-rc1, build bug] Re: [PATCH 05/11] Add support for the
 MAX3100 SPI UART.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090408112456.2669306f@lxorguk.ukuu.org.uk>
References: <20090408061811.GA22767@elte.hu>
	<49DC481F.4020608@cn.fujitsu.com>
	<20090408112456.2669306f@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 8 Apr 2009 11:24:56 +0100

>> >    CHK     include/linux/compile.h
>> >  make[2]: *** No rule to make target `drivers/serial/max3100.o', needed by `drivers/serial/built-in.o'.  Stop.
>> >  make[1]: *** [drivers/serial] Error 2
>> >  make[1]: *** Waiting for unfinished jobs....
>> 
>> I hit the same build error just now...
> 
> I'll take a look - but yes I did build it here so I'm not sure what is up
> right now.

Missing "git add", or something like that, for sure.
