Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYJ1Xab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYJ1Xab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYJ1XaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:30:20 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:40215 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYJ1XaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:30:19 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=ngiKoxkIjVNkX2zgWOMA:9 a=kBV36anvxH5OlDcLHBmMkaOQYIIA:4 a=WDfWUHGzopcA:10 a=PKvB5Nzo7TkA:10
Message-ID: <4907A087.8070506@shaw.ca>
Date: Tue, 28 Oct 2008 17:30:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Marc Donner <donner@dbd-breitband.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tg3:No interrupt was generated using MSI, switching to INTx mode.
 Please report this failure to the PCI maintainer and include system chipset
 information.
References: <fa.DGFAgeS7UIX09ggBLWLxaYf6hWE@ifi.uio.no>
In-Reply-To: <fa.DGFAgeS7UIX09ggBLWLxaYf6hWE@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Donner wrote:
> Hi @all,
> 
> we have installed a dual port Brodcam Gigabit Ethernet NIC, and get the
> following error in dmesg:
> 
> tg3: eth1 No interrupt was generated using MSI, switching to INTx mode.
> Please report this failure to the PCI maintainer and include system
> chipset information.
> 
> Who is responsible for this error message? We are using Kernel 2.6.21.1
> and the NIC Chipset is a Broadcom BCM5715CKPBG

Please post your full dmesg output from bootup, lspci -vvv output and 
what kind of motherboard or system you're using.

Also it would be useful to test a newer kernel to see if the problem 
still occurs. 2.6.21 is quite old these days.
