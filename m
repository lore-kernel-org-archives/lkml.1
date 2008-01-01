Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYAAVa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYAAVa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYAAVaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:30:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYAAVaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:30:17 -0500
Message-ID: <477AAF95.2060806@zytor.com>
Date: Tue, 01 Jan 2008 13:24:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<20080101164338.GA901@elte.hu>	<20080101183238.74307174@weinigel.se>	<20080101184659.GA9250@elte.hu>	<20080101203518.26e889f2@weinigel.se>	<477A9B98.2090608@keyaccess.nl> <20080101215545.0785beef@weinigel.se>
In-Reply-To: <20080101215545.0785beef@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> 
>> For that matter does anyone actually have video cards old enough for us
>> to care actually still in use with Linux today ? 
> 
> I'm afraid that some PC104 systems may still use ancient video cards.
> 

PC/104 is actual ISA, not even LPC...

	-hpa
