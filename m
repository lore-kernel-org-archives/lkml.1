Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZAEL0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZAEL0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZAELZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:25:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33624 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZAELZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:25:53 -0500
Date: Mon, 5 Jan 2009 12:25:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/10] PCI PM: Call pci_fixup_device from legacy routines
Message-ID: <20090105112551.GL27199@atrey.karlin.mff.cuni.cz>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl> <200812302344.31719.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812302344.31719.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The size of drivers/pci/pci-driver.c can be reduced quite a bit
> if pci_fixup_device() is called from the legacy PM callbacks, so make
> it happen.
> 
> No functional changes should result from this.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
