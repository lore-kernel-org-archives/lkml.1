Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbXLPArZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbXLPArZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXLPArQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:47:16 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:57609 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXLPArP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:47:15 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2XZYCZhGR6SeONk3WZPKb
Message-ID: <4764757B.6060604@reed.com>
Date: Sat, 15 Dec 2007 19:46:51 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Allen Martin <AMartin@nvidia.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: More info on port 80 symptoms on MCP51 machine.
References: <475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<475E95A3.3070801@davidnewall.com>	<Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com>	<20071211163017.GD16750@one.firstfloor.org>	<475EBFBA.6090301@keyaccess.nl>	<20071211191649.GB3437@elf.ucw.cz>	<475EEC75.80609@keyaccess.nl>	<47603F66.3070108@reed.com>	<476043DA.5000602@keyaccess.nl>	<47604B71.7090902@keyaccess.nl> <20071212210143.48721a41@the-village.bc.nu> <47604EA4.50504@zytor.com> <F72FA20C31DD4F4C997B91C5B3690A090263BC96@hqemmail07.nvidia.com>
In-Reply-To: <F72FA20C31DD4F4C997B91C5B3690A090263BC96@hqemmail07.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allen Martin wrote:
> Nothing inside the chipset should be decoding port 80 writes.  It's 
> possible this board has a port 80 decoder wired onto the board that's 
> misbehaving.  I've seen other laptop boards with port 80 decoders
> wired onto the board, even if the 7 segment display is only populated
> on debug builds.  
>
>   
This is very helpful.  So the next question is there something on the 
laptop mainboard.

Any idea how to look for such a thing?   I am not averse to taking the 
laptop apart to look at the mainboard.
