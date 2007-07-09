Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbXGISq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbXGISq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXGISqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:46:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:1410 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXGISqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:46:21 -0400
Date: Mon, 9 Jul 2007 20:46:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Adrian Bunk <bunk@stusta.de>, Zhang Rui <rui.zhang@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
In-Reply-To: <20070709174544.2a6b7067@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
References: <20070709145755.GD3492@stusta.de> <20070709174544.2a6b7067@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9 2007 17:45, Alan Cox wrote:
>
>> This patch contains the scheduled removal of the ACPI procfs interface.
>
>What part of "we do not gratuitously break user space interfaces" is so
>hard for people to understand.

Generally I am with you on that, but if everyone keeps on using /proc --
and I do[*] -- we will never get rid of it.


[*] Does someone have an alternative for /proc/acpi/battery/BAT1/{state,info}?

Thanks,
	Jan
-- 
