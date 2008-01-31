Return-Path: <linux-kernel-owner+w=401wt.eu-S1764614AbYAaFHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764614AbYAaFHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYAaFH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:07:26 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37219 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYAaFHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:07:25 -0500
Date: Thu, 31 Jan 2008 06:07:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oldconfig/menuconfig help text display for "choice" items
Message-ID: <20080131050727.GB30989@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0801310157050.13320@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801310157050.13320@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 02:02:19AM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> when running oldconfig, I got to see some new IO delay questions,
> and tried displaying its info using ?.
> 
> 	IO delay type
> 	  1. port 0x80 based port-IO delay [recommended] (IO_DELAY_0X80) (NEW)
> 	> 2. port 0xed based port-IO delay (IO_DELAY_0XED) (NEW)
> 	  3. udelay based port-IO delay (IO_DELAY_UDELAY) (NEW)
> 	  4. no port-IO delay (IO_DELAY_NONE) (NEW)
> 	choice[1-4]: ?
> 
> 	Sorry, no help available for this option yet.
> 
> 
> The IO_DELAY_* "config" items have a help text, while the "choice" 
> item does not.
> Are there any plans on 'fixing' oldconfig to somehow tell me something 
> about such new options?

IT should be fixed but I have not looked into to it.
Roman?

	Sam
