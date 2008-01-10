Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYAJKan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYAJKan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYAJKad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:30:33 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:35579 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYAJKac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:30:32 -0500
Date: Thu, 10 Jan 2008 10:30:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yi Yang <yi.y.yang@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
Message-ID: <20080110103019.GA9403@srcf.ucam.org>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com> <1199688961.3551.19.camel@yangyi-dev.bj.intel.com> <1199917306.9596.3.camel@yangyi-dev.bj.intel.com> <200801100943.08780.maximlevitsky@gmail.com> <1199923176.3827.13.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199923176.3827.13.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 07:59:36AM +0800, Yi Yang wrote:

> Maybe this is a good idea, but i don't know the relationships between
> acpi devices, devices, pci devices and pnp devices. If we can merge all
> these things together, that will be a great job.

Let's not merge this yet, then, otherwise we'll be forced to carry 
around a sysfs API that's of no real use.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
