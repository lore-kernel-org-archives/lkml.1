Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYLEEP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYLEEP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYLEEPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:15:13 -0500
Received: from main.gmane.org ([80.91.229.2]:49547 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYLEEPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:15:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sony-ericsson W800 cellular doesn't work as an usb mass storage
 device
Date: Thu, 04 Dec 2008 22:10:50 -0600
Message-ID: <4938A9CA.5000903@shaw.ca>
References: <4937447F.6070805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Robby Workman <rw@rlworkman.net>
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <4937447F.6070805@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niklas "Nille" Åkerström wrote:
> Please CC any replies; not subscribed to list
> 
> I can't mount my sony-ericsson W800 cellular as an usb mass storage 
> device (it doesn't show up as an device).
> I run slackware-current (slackware 12.2 rc1)
> Using kernel 2.6.27.7
> It doesn't even show up when i run 'fdisk -l'

What do you mean doesn't show up as a device? There doesn't seem to be 
anything unusual in the kernel log, you should have a /dev/sda1 device 
available (at least if udev, etc. are doing their job)..

> 
> How ever running slackware 12.1 using kernel 2.6.24.5 works (used my 
> other box for 12.1 testing)
> I also tried the 12.1 kernel 2.6.24.5 in slackware 12.2 rc1 and then it 
> works.
> So it's seems kernel related. (but i'm not experienced enuff to know)
> 
> Kernel config 2.6.27.7 http://pastebin.com/m4ba5debe
> Kernel config 2.6.24.5 http://pastebin.com/m20a78c4f
> dmesg when pluging in the device on 2.6.27.7 http://pastebin.com/m56d5e2e8
> dmesg when pluging in the device on 2.6.24.5 running 12.1 
> http://pastebin.com/m65e4fd04
> dmesg when pluging in the device on 2.6.24.5 running current 
> http://pastebin.com/m2ac79d09
> 
> My computer is an Compaq Presario 2800
> Phone Sony Ericsson W800i 0fce:d028
> What other information would be useful?
> 
> I searched the mailing list and found http://lkml.org/lkml/2008/9/11/276 
> which seems releated but there was no answer.
> 
> (please cc me on any reply)
> Thanks,
> Nille
> 

