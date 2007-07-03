Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbXGCGk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbXGCGk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbXGCGkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:40:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:31680 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXGCGkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=F19Db8Ymxg3/TzAKoFlIgAqAP7rKpEDcq7isWoMIWJc7I7edAlw+Udqh6OciaVg1ADO4Hzd+2kJYA/EFChtsTdQCLB8jAaXs1g/0WRTmisrZTfT3mDUg5GnzZBOXYeuMbnN0LMkxFv5Khd+bQKO5lwuCR/XMYg/FTf0qHix4OzU=
Message-ID: <4689EF48.8090506@gmail.com>
Date: Tue, 03 Jul 2007 15:40:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Subject: Re: ata1: soft resetting port
References: <1182260902.14805.60.camel@localhost>
In-Reply-To: <1182260902.14805.60.camel@localhost>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> Dear List,
> 
> since the switch to 
> 
> CONFIG_ATA=y
> CONFIG_ATA_ACPI=y
> CONFIG_ATA_PIIX=y,
> 
> the ATA_PIIX driver manages both, internal sata disk aswell as cd/dvd
> rom. However I am being flooded with the error messages below (well they
> appear from time to time, dominating dmesg). 
> 
> This happens on kernel 2.6.22-rc5, I am copying relevant parts from dmesg:

Does 2.6.22-rc7 fare better?

-- 
tejun
