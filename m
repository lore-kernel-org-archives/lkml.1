Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZKNCDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZKNCDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZKNCC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:02:59 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:56922 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbZKNCC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:02:58 -0500
Message-ID: <4AFE0FCC.4020405@ahsoftware.de>
Date: Sat, 14 Nov 2009 03:02:52 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de> <4AFDEB57.2050908@gmail.com>
In-Reply-To: <4AFDEB57.2050908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.11.2009 00:27, schrieb Robert Hancock:
>> (And here comes the problem)>
>> Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed
>> USB device using ehci_hcd and address 3
>> Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware
>> changed
>> Nov 13 19:47:39 krabat kernel: [ 2661.120489] usb 9-7: USB disconnect,
>> address 3
>
> That sounds like the device started reporting a different firmware
> string after it woke up, and the kernel decided it wasn't the same
> device anymore and triggered a disconnect/reconnect..
> --

I don't think it's a problem with the devices. I'm using them (more than 
1) for some months now and never have had any problems. The problem 
first started, when I've switched  to the box with the p55-express and I 
still don't have any problems with these devices on other machines.

Kind regards,

Alexander Holler
