Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbXKPKCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbXKPKCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbXKPKCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:02:15 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:59305 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbXKPKCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:02:14 -0500
Date: Fri, 16 Nov 2007 10:02:03 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on odd APIC behavior
In-Reply-To: <200711151905.03005.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64N.0711160959010.25869@blysk.ds.pg.gda.pl>
References: <200711150054.34312.oliver@neukum.org> <200711151627.25622.oliver@neukum.org>
 <Pine.LNX.4.64N.0711151637220.19041@blysk.ds.pg.gda.pl>
 <200711151905.03005.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Oliver Neukum wrote:

> On irq 20, there's an UHCI, on irq 19 is an EHCI. For every interrupt on 20
> there's a spurious interrupt on 19. USB devices on bus of the controller on 20
> work. So I know all interrupts are seen. ERR does not increase. Interrupts
> for devices on the bus of the controller on 19 arrive at 19 only.

 I suggest you try to sort it out with the maintainers of the UHCI and 
EHCI drivers then.

  Maciej
