Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbXGLHnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbXGLHnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbXGLHm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:42:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50442 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbXGLHm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:42:56 -0400
Message-ID: <4695DB7D.40201@garzik.org>
Date: Thu, 12 Jul 2007 03:42:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: AHCI linkage error in 2.6.22+git
References: <Pine.SOC.4.64.0707121004410.18637@math>
In-Reply-To: <Pine.SOC.4.64.0707121004410.18637@math>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
> Trying to compile modular AHCI on ppc (prep):
> 
>   MODPOST 648 modules
> ERROR: "ahci_port_resume" [drivers/ata/ahci.ko] undefined!

Do you have CONFIG_PM disabled?

	Jeff



