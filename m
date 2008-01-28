Return-Path: <linux-kernel-owner+w=401wt.eu-S1757693AbYA1B4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbYA1B4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYA1Bz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:55:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59731 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYA1Bz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:55:58 -0500
Message-ID: <479D3606.8020200@zytor.com>
Date: Sun, 27 Jan 2008 17:55:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/9] x86_64: Switch to .data.compressed in arch/x86/boot/compressed/vmlinux_64.scr
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>	 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>	 <86802c440801261659s1102f38cr16858d350929b0e1@mail.gmail.com>	 <1201471499.18241.23.camel@localhost.localdomain>	 <86802c440801271538xce702c2l6b0ddbccfcdf9553@mail.gmail.com>	 <479D22CF.6060201@zytor.com> <86802c440801271749h3c479b81rf1a5edda25f1f259@mail.gmail.com>
In-Reply-To: <86802c440801271749h3c479b81rf1a5edda25f1f259@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> payload.compressed ?
> 

We can call it .payload, or just .rodata.compressed.

	-hpa
