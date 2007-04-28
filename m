Return-Path: <linux-kernel-owner+w=401wt.eu-S1031532AbXD1M7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031532AbXD1M7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 08:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031160AbXD1M7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 08:59:45 -0400
Received: from www.osadl.org ([213.239.205.134]:41742 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031532AbXD1M7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 08:59:44 -0400
Subject: Re: Problem:  2.6.21 won't boot
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Riccardo Ricci <rricci@nuovanetmore.it>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <55875.172.20.1.1.1177699628.squirrel@srv01.nuovanetmore.it>
References: <55875.172.20.1.1.1177699628.squirrel@srv01.nuovanetmore.it>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 15:01:46 +0200
Message-Id: <1177765306.7646.152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 20:47 +0200, Riccardo Ricci wrote:
> Hi to everyone,
> i've compiled kernel 2.6.21 on my debian PIII 650 / 256MB / Dell Latitude
> J650GT. With 2.6.20.8 all works very good, with 2.6.21 don't boot... While
> booting it stops after ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9
> 10 11 12 14 15).

Can you capture the 2.6.21 boot log via serial console ?

	tglx


