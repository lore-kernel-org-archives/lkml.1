Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbXERIrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbXERIrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXERIrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:47:33 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56703 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbXERIrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:47:32 -0400
X-Auth-Info: e0GNAW8jEecYByNb3wjpIOivlF+D2gwhIaAFXZkvzEU=
X-Auth-Info: e0GNAW8jEecYByNb3wjpIOivlF+D2gwhIaAFXZkvzEU=
X-Auth-Info: e0GNAW8jEecYByNb3wjpIOivlF+D2gwhIaAFXZkvzEU=
X-Auth-Info: e0GNAW8jEecYByNb3wjpIOivlF+D2gwhIaAFXZkvzEU=
X-Auth-Info: e0GNAW8jEecYByNb3wjpIOivlF+D2gwhIaAFXZkvzEU=
Message-ID: <464D6951.9050909@grandegger.com>
Date: Fri, 18 May 2007 10:52:33 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: emin ak <eminak71@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt3
References: <20070517194143.GA25394@elte.hu>	 <2cf1ee820705180039l1d72005fq2169f8fa36e12377@mail.gmail.com>	 <1179474804.12981.57.camel@chaos>	 <2cf1ee820705180110y740de989ma48553d4b2188845@mail.gmail.com> <1179477092.12981.61.camel@chaos>
In-Reply-To: <1179477092.12981.61.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Please do not top post !
> 
> On Fri, 2007-05-18 at 11:10 +0300, emin ak wrote:
>> Yes, 2.6.21 was compiled and boot successfully for ppc, Is 85xx family
>> supported for powerpc arch?
> 
> I don't know. You might ask the folks on the ppc mailing list.

E.g. check http://lxr.free-electrons.com/source/arch/powerpc/configs/. 
Even your board seems supported. But you need a boot loader aware of the 
  Open Firmware Flat Device Tree.

Wolfgang.

