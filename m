Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbXBJDfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbXBJDfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 22:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXBJDfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 22:35:05 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:54380 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbXBJDfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 22:35:01 -0500
Date: Sat, 10 Feb 2007 03:34:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-ID: <20070210033424.GA16490@srcf.ucam.org>
References: <200702071418.51058.lenb@kernel.org> <20070209230928.GD3949@ucw.cz> <20070209172410.e2c4566b.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209172410.e2c4566b.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 05:24:10PM -0800, Kristen Carlson Accardi wrote:

> The user interface for the Bay driver is via sysfs - it is a platform
> driver

Though, ideally, in the long run it'll be tied into the PATA/SATA 
interface that it's associated with. That involves a little more magic, 
though :)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
