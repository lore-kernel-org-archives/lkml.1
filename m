Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZAELTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZAELTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZAELTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:19:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50555 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAELTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:19:34 -0500
Date: Mon, 5 Jan 2009 12:19:31 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC][PATCH 8/10] PCI PM: Register power state of devices during initialization
Message-ID: <20090105111931.GI27199@atrey.karlin.mff.cuni.cz>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl> <200812302345.55072.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812302345.55072.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Use the observation that the power state of a PCI device can be
> loaded into its pci_dev structure as soon as pci_pm_init() is run for
> it and make that happen.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <Pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
