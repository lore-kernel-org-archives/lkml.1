Return-Path: <linux-kernel-owner+w=401wt.eu-S1161401AbXBHDRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161401AbXBHDRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161429AbXBHDRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:17:23 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40712 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161401AbXBHDRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:17:22 -0500
Message-ID: <45CA9638.2010209@garzik.org>
Date: Wed, 07 Feb 2007 22:17:12 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.20
References: <20070208002932.GC4796@kroah.com>
In-Reply-To: <20070208002932.GC4796@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Greg Kroah-Hartman (3):
>       PCI: remove duplicate device id from ata_piix
>       PCI: remove duplicate device id from ipr
>       Revert "PCI: remove duplicate device id from ata_piix"


If these are coming out of quilt, why add these commit-then-revert 
changesets at all?

	Jeff


