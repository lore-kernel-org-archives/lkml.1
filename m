Return-Path: <linux-kernel-owner+w=401wt.eu-S936504AbXEVPff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936504AbXEVPff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935701AbXEVP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:26:07 -0400
Received: from bay0-omc2-s21.bay0.hotmail.com ([65.54.246.157]:65068 "EHLO
	bay0-omc2-s21.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935700AbXEVP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:26:04 -0400
Message-ID: <BAY20-F21042242E1DE82AF8A4EE7F9360@phx.gbl>
X-Originating-IP: [88.112.28.249]
X-Originating-Email: [paapaa125@hotmail.com]
In-Reply-To: <4652FD77.6090709@shaw.ca>
From: "Paa Paa" <paapaa125@hotmail.com>
To: hancockr@shaw.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: Enabling power states for Core 2 Duo
Date: Tue, 22 May 2007 15:26:01 +0000
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 22 May 2007 15:26:03.0486 (UTC) FILETIME=[8259DFE0:01C79C85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>I'm probably missing something crucial here. So how do I enable power 
>>states? I'm using 64-bit Gentoo. My mobo is Asus P5B Deluxe. Otherwise 
>>ACPI works fine.
>
>The BIOS has to expose this support in ACPI, if it doesn't (which is often 
>the case on desktop boards) you won't get any C-state support (well, except 
>for C1 which is just the normal halt state).

But unless I'm not mistaken, I don't have even the C1 state available. I 
seem to have only C0 according to "active state". "Active state is the sleep 
state currently used when the system is idle", isn't it? Here is the source:

http://acpi.sourceforge.net/documentation/processor.html

But are you saying that with most desktop mobos one doesn't usually have the 
different power states available at all? So basically the only means to 
conserve power is to scale the frequency?

_________________________________________________________________
Express yourself instantly with MSN Messenger! Download today it's FREE! 
http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/

