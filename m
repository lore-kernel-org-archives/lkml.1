Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344Ab0ADJx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0ADJx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0ADJxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:53:55 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:36703 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0ADJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 04:53:54 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 12/12] PM / r8169: Add simplified run-time PM support
Date: Mon, 4 Jan 2010 10:53:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <201001032201.14087.rjw@sisk.pl> <20100104083108.GD1372@ucw.cz>
In-Reply-To: <20100104083108.GD1372@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001041053.52099.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. Januar 2010 09:31:08 schrieb Pavel Machek:
> > You can't save power, you can only save energy.  Wh is just an energy unit.
> 
> Of course we can save power, you just did :-).
> 
> (And in some cases -- data centers, limited cooling -- you are limited
> by power, not energy. You are right that on notebooks, energy is more
> important.)

If possible less power is better on a laptop, fans are loud and take
energy to run.

	Regards
		Oliver
