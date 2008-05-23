Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbYEWXjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbYEWXjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYEWXjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:39:25 -0400
Received: from gw.goop.org ([64.81.55.164]:56414 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYEWXjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:39:25 -0400
Message-ID: <4837558E.40705@goop.org>
Date: Sat, 24 May 2008 00:38:54 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix v2
References: <200805110030.15510.yhlu.kernel@gmail.com>	 <200805180118.57863.yhlu.kernel@gmail.com>	 <200805211840.18619.yhlu.kernel@gmail.com>	 <200805221520.19259.yhlu.kernel@gmail.com> <86802c440805231608g314690fu3125034804ac51fd@mail.gmail.com>
In-Reply-To: <86802c440805231608g314690fu3125034804ac51fd@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Jeremy,
>
> your config works on XEN of 5.2 as domU
> ( I added ext2 support...)
>   

The boot log you attached is for a kernel booting either natively or in 
an hvm domain ("Booting paravirtualized kernel on bare hardware").  Were 
you booting it as an hvm guest rather than a pv one?

    J
