Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbXGNUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbXGNUXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762351AbXGNUXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:23:08 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:60667 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761022AbXGNUXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:23:07 -0400
Date: Sat, 14 Jul 2007 23:23:05 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: AHCI linkage error in 2.6.22+git
In-Reply-To: <4695DB7D.40201@garzik.org>
Message-ID: <Pine.SOC.4.64.0707142322510.26494@math.ut.ee>
References: <Pine.SOC.4.64.0707121004410.18637@math> <4695DB7D.40201@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   MODPOST 648 modules
> > ERROR: "ahci_port_resume" [drivers/ata/ahci.ko] undefined!
> 
> Do you have CONFIG_PM disabled?

Yes, disabled.

-- 
Meelis Roos (mroos@linux.ee)
