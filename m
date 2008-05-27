Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbYE0Vro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbYE0Vro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYE0Vrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:47:37 -0400
Received: from gw.goop.org ([64.81.55.164]:43351 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbYE0Vrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:47:37 -0400
Message-ID: <483C8157.7080702@goop.org>
Date: Tue, 27 May 2008 22:47:03 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
References: <200805110030.15510.yhlu.kernel@gmail.com>	 <200805180118.57863.yhlu.kernel@gmail.com>	 <200805211840.18619.yhlu.kernel@gmail.com>	 <200805251000.10205.yhlu.kernel@gmail.com>	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>	 <483C70F9.2030901@goop.org>	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>	 <483C7BB0.6080901@goop.org> <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
In-Reply-To: <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> thanks for the explanation...
>
> method 1 need to be done.
>
> BTW, XEN PV only support 32 bit?
>   

At the moment, but 64-bit is being worked on.  Any solution must work 
for both.

    J
