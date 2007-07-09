Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbXGISzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbXGISzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXGISzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:55:20 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:53426 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbXGISzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:55:19 -0400
Date: Mon, 9 Jul 2007 19:55:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20070709185501.GA32724@srcf.ucam.org>
References: <20070709145755.GD3492@stusta.de> <20070709174544.2a6b7067@the-village.bc.nu> <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 08:46:20PM +0200, Jan Engelhardt wrote:

> Generally I am with you on that, but if everyone keeps on using /proc --
> and I do[*] -- we will never get rid of it.
> 
> 
> [*] Does someone have an alternative for /proc/acpi/battery/BAT1/{state,info}?

The battery class work will provide one in the long run, but it's not 
mainline yet.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
