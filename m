Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbXLQBya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbXLQBya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 20:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763533AbXLQByU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 20:54:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763496AbXLQByT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 20:54:19 -0500
Message-ID: <4765D684.9090304@zytor.com>
Date: Sun, 16 Dec 2007 17:53:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <47659BAF.8030304@zytor.com> <4765D56A.4090803@gmail.com>
In-Reply-To: <4765D56A.4090803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> Do you expect a BIOS update to be able to fix it? If so, I guess any DMI 
> hack should take BIOS version into account.
> 

Hard to know without knowing what it is.

	-hpa
