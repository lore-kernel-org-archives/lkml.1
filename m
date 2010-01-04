Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094Ab0ADVAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0ADVAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084Ab0ADVAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:00:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59856 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0ADVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:00:48 -0500
Date: Mon, 4 Jan 2010 22:00:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
Subject: Re: [RFC][PATCH 12/12] PM / r8169: Add simplified run-time PM
 support
Message-ID: <20100104210040.GA20001@elf.ucw.cz>
References: <200911160047.46299.rjw@sisk.pl>
 <201001032201.14087.rjw@sisk.pl>
 <20100104083108.GD1372@ucw.cz>
 <201001042051.08692.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001042051.08692.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Which means it saves 0.6W :-). Measuring power in Wh/h is "interesting".
> > > 
> > > You can't save power, you can only save energy.  Wh is just an energy unit.
> > 
> > Of course we can save power, you just did :-).
> > 
> > (And in some cases -- data centers, limited cooling -- you are limited
> > by power, not energy.
> 
> But still energy is what you pay for, isn't it?

Energy is what you pay for, but if you eat too much power, data centre
overheats and goes down.

> > You are right that on notebooks, energy is more important.)
> 
> You may require less power to run, so if that's what you mean by "saving", then
> I agree. :-)

Yes, that's what I meant by saving :-), and yes, they are very
related.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
