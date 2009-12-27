Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbZL0TsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbZL0TsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 14:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZL0TsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 14:48:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60339 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbZL0TsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 14:48:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 12/12] PM / r8169: Add simplified run-time PM support
Date: Sun, 27 Dec 2009 20:48:37 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291644.27288.rjw@sisk.pl> <20091215114956.GA1415@ucw.cz>
In-Reply-To: <20091215114956.GA1415@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912272048.37332.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009, Pavel Machek wrote:
> Hi!
> 
> > Use the PCI run-time power management framework to add simplified
> > run-time PM support to the r8169 driver.  Namely, make the driver
> > suspend the device when the link is off and set it up for generating
> > wake-up event after the link has been detected again.
> 
> Nice!
> 
> Do you have any idea how much power it saves?

No, but there should be a power meter somewhere here ...

I'll let you know if I can find it.

Rafael
