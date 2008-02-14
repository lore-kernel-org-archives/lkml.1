Return-Path: <linux-kernel-owner+w=401wt.eu-S1765051AbYBNNJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765051AbYBNNJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYBNNIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:08:52 -0500
Received: from h155.mvista.com ([63.81.120.155]:8170 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751376AbYBNNIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:08:51 -0500
Message-ID: <47B43D9B.3020105@ru.mvista.com>
Date: Thu, 14 Feb 2008 16:09:47 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       muli@il.ibm.com, jdmason@kudzu.us, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
References: <20080213001506.GA13933@kroah.com> <20080213172824.GB10733@kroah.com> <20080213181655.GB8960@kroah.com> <200802132320.37172.bzolnier@gmail.com>
In-Reply-To: <200802132320.37172.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: mark "ide=reverse" option as obsolete

> - it is valid only if "Probe IDE PCI devices in the PCI bus order
>   (DEPRECATED)" config option is used

> - Greg needs to remove pci_get_device_reverse() for PCI core changes

> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
