Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbXGDJST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbXGDJST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXGDJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:18:09 -0400
Received: from aun.it.uu.se ([130.238.12.36]:32813 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbXGDJSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:18:08 -0400
Date: Wed, 4 Jul 2007 11:17:51 +0200 (MEST)
Message-Id: <200707040917.l649HpCg016960@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: alan@lxorguk.ukuu.org.uk, mrmacman_g4@mac.com
Subject: Re: Libata PATA status
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 23:04:26 -0400, Kyle Moffett wrote:
> Has anyone started a rewrite of the PPC/PowerMac IDE  
> driver?  The current one is in "drivers/ide/ppc/pmac.c", and supports  
> these chipsets:
>    OHare ATA
>    Heathrow ATA
>    KeyLargo ATA-3
>    KeyLargo ATA-4
>    UniNorth ATA-6 (IE: Kauai)
>    K2 ATA-6
>    Shasta ATA-6
> 
> I'd be willing to test drivers for the UniNorth ATA-6 and K2 ATA-6,  
> as well as possibly the KeyLargo ATA-3/4, depending on what the old  
> MDD G4 in my closet has.  Sadly my libata-foo is insufficient for me  
> to do anything useful (other than thoroughly testing my backup- 
> restoration procedure, maybe :-D).

And I'd be happy to test a libata pmac driver on Heathrow (Beige G3)
and KeyLargo ATA-3/UniNorth ATA-6 (eMac G4).
