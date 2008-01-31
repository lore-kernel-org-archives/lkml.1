Return-Path: <linux-kernel-owner+w=401wt.eu-S934704AbYAaRyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704AbYAaRyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbYAaRxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:53:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbYAaRxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:53:50 -0500
Message-ID: <47A209C0.7010204@zytor.com>
Date: Thu, 31 Jan 2008 09:47:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: about relocs.c on x86
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com> <20080131095223.GA11867@elte.hu> <1201773740.23523.17.camel@brick> <20080131101111.GB11867@elte.hu>
In-Reply-To: <20080131101111.GB11867@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> ( Hey, and maybe someone is crazy enough to try to port the math-emu 
>   code to 64-bit and boot Linux up on 64-bit with all user-space FPU ops 
>   emulated. It would be one of the most useless hacks of all times, and 
>   that certainly has a certain kind of sick appeal to it, doesnt it? ;-))
> 

It'd take a lot of work, since the x86-64 ABI requires SSE2.

	-hpa

