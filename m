Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbXCSK3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbXCSK3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933089AbXCSK3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:29:31 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:45280 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370AbXCSK3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:29:30 -0400
X-ME-UUID: 20070319102928737.B3FBD1C00098@mwinf2102.orange.fr
Message-ID: <45FE6607.6050905@wanadoo.fr>
Date: Mon, 19 Mar 2007 11:29:27 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: I can't compile with success because ueagle-atm.ko undefined
References: <45FC74C7.3010406@wanadoo.fr> <20070318161100.GQ752@stusta.de>
In-Reply-To: <20070318161100.GQ752@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I tried the kernel 2.6.19 and patched it with suspend2 for 2.6.19
For 2.6.20, suspend2 is on development, so I can't use it



Adrian Bunk a écrit :
> On Sun, Mar 18, 2007 at 12:07:51AM +0100, Thibaud Hulin wrote:
>> Hi,
>> I can't compile with success my kernel, i've got this error message :
>>
>>   Building modules, stage 2.
>>   MODPOST 1750 modules
>> WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
>> WARNING: "try_to_freeze" [drivers/usb/atm/ueagle-atm.ko] undefined!
>> make[2]: *** [__modpost] Erreur 1
>> make[1]: *** [modules] Erreur 2
> 
> You didn't mention the kernel version, but this is a bug in kernels 
> 2.6.20 and 2.6.20.1 fixed in kernel 2.6.20.2 (and 2.6.20.3).
> 
>> When I uncheck this module, the compiled kernel works, but there are 
>> many problems and the kernel fails after minutes.
>> ...
> 
> That sounds like an unrelated problem that should be reported.
> 
>> Thanks for help,
>> Thibaud.
> 
> cu
> Adrian
> 


