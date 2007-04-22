Return-Path: <linux-kernel-owner+w=401wt.eu-S1030944AbXDVPJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030944AbXDVPJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 11:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030941AbXDVPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 11:09:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49976 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030937AbXDVPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 11:09:33 -0400
Date: Sun, 22 Apr 2007 16:13:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: rene@exactcode.de, todorovic.s@googlemail.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: InitIO SCSI: Volunteers required
Message-ID: <20070422161302.2a52b908@the-village.bc.nu>
In-Reply-To: <20070422141423.GA8928@infradead.org>
References: <20070420103849.7358f1f1@the-village.bc.nu>
	<20070422141423.GA8928@infradead.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Once again a pci_get_device conversation isn't all that helpfull at all.
> fortunately in this case I've done a patch to convert this driver to
> proper pci probing in 2004, and I've attached the forward-ported version
> below now that we've actually found some testers that weren't locatable
> back then..
> 
> This doesn't change much outside the initialization and irq code, so
> any additional de-crappyfication will hopefully apply ontop.

Can this wait Christoph as it'll clash horribly with all the work I've
done. Once the original changes are checked out by folks who have
volunteered to do that I'll see these get merged in as well.

Alan

