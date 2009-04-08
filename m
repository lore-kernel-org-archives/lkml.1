Return-Path: <linux-kernel-owner+w=401wt.eu-S1761221AbZDHK0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221AbZDHK0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZDHKZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:25:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45875 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754856AbZDHKZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:25:52 -0400
Date: Wed, 8 Apr 2009 11:24:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christian Pellegrin <chripell@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-rc1, build bug] Re: [PATCH 05/11] Add support for the MAX3100
 SPI UART.
Message-ID: <20090408112456.2669306f@lxorguk.ukuu.org.uk>
In-Reply-To: <49DC481F.4020608@cn.fujitsu.com>
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
	<20090407154840.18020.82549.stgit@t61.ukuu.org.uk>
	<20090408061811.GA22767@elte.hu>
	<49DC481F.4020608@cn.fujitsu.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >    CHK     include/linux/compile.h
> >  make[2]: *** No rule to make target `drivers/serial/max3100.o', needed by `drivers/serial/built-in.o'.  Stop.
> >  make[1]: *** [drivers/serial] Error 2
> >  make[1]: *** Waiting for unfinished jobs....
> 
> I hit the same build error just now...

I'll take a look - but yes I did build it here so I'm not sure what is up
right now.

