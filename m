Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXCQXH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXCQXH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXCQXH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:07:58 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:8745 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbXCQXH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:07:57 -0400
X-ME-UUID: 20070317230755657.A06BA1C00087@mwinf2128.orange.fr
Message-ID: <45FC74C7.3010406@wanadoo.fr>
Date: Sun, 18 Mar 2007 00:07:51 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: I can't compile with success because ueagle-atm.ko undefined
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I can't compile with success my kernel, i've got this error message :

   Building modules, stage 2.
   MODPOST 1750 modules
WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
WARNING: "try_to_freeze" [drivers/usb/atm/ueagle-atm.ko] undefined!
make[2]: *** [__modpost] Erreur 1
make[1]: *** [modules] Erreur 2

When I uncheck this module, the compiled kernel works, but there are 
many problems and the kernel fails after minutes.

I use a Nvdia Geforce graphic card.


Thanks for help,
Thibaud.

