Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXJ2NsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXJ2NsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbXJ2NsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:48:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55017 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752327AbXJ2NsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:48:05 -0400
Date: Mon, 29 Oct 2007 13:50:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dirk Hohndel <hohndel@linux.intel.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciserial_resume_one ignored return value of
 pci_enable_device
Message-ID: <20071029135004.1fc4fc64@the-village.bc.nu>
In-Reply-To: <20071029132817.GA20449@bigserver.hohndel.org>
References: <20071029132817.GA20449@bigserver.hohndel.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 06:28:17 -0700
Dirk Hohndel <hohndel@linux.intel.com> wrote:

> [PATCH] pciserial_resume_one ignored return value of pci_enable_device
> 
> Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

Acked-by: Alan Cox <alan@redhat.com>

Not sure its worth the hassle but I guess someone could pull a hotplug
PCI serial card and then resume.
