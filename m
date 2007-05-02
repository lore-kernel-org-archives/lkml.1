Return-Path: <linux-kernel-owner+w=401wt.eu-S1767132AbXEBWmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767132AbXEBWmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767143AbXEBWmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:42:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:39258 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767132AbXEBWms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:42:48 -0400
Date: Wed, 2 May 2007 18:41:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Nicolas Boichat <nicolas@boichat.ch>
cc: Rudolf Marek <r.marek@assembler.cz>,
       LM Sensors <lm-sensors@lm-sensors.org>, bytes@linuxgazette.net,
       debian-user@lists.debian.org, linux-kernel@vger.kernel.org
Subject: Re: coretemp - take3
In-Reply-To: <45FE0EE3.2030201@boichat.ch>
Message-ID: <Pine.LNX.4.64.0705021841280.14579@p34.internal.lan>
References: <45FDC7A4.9070601@assembler.cz> <45FE0EE3.2030201@boichat.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Mar 2007, Nicolas Boichat wrote:

> Rudolf Marek wrote:
>> Hello all,
>>
>> I'm CCing all interested parties, if some isn't please tell!
>>
>> On URL bellow is current version of coretemp driver.
>>
>> http://ssh.cz/~ruik/patches/
>
> Small glitch in coretemp_init:
>
>    printk(KERN_NOTICE DRVNAME ": This driver uses undocumented features"
>
>        "of Core CPU. Temperature might be wrong!\n");
>
>
> Prints this in dmesg:
>
> [46487.231000] coretemp: This driver uses undocumented featuresof Core CPU. Temperature might be wrong!
>
>
> (Notice the space missing between "features" and "of")
>
> Best regards,
>
> Nicolas
>

This did not make it into 2.6.21?  Will it get into 2.6.22?
