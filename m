Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbXA3A3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbXA3A3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXA3A3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:29:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35122 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbXA3A3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:29:30 -0500
Date: Mon, 29 Jan 2007 16:26:58 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070129162658.798c2e6a@freekitty>
In-Reply-To: <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<1169931333.17469.125.camel@localhost.localdomain>
	<20070129113159.7ad22e4c@freekitty>
	<1170101430.29240.34.camel@localhost.localdomain>
	<20070129133849.1b523226@freekitty>
	<1170109401.29240.49.camel@localhost.localdomain>
	<Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
	<20070129144055.151cfe52@freekitty>
	<Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org>
	<20070129154518.40b0b3d3@freekitty>
	<Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org>
	<20070129161626.33277eb1@freekitty>
	<Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 16:25:48 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 29 Jan 2007, Stephen Hemminger wrote:
> > 
> > On one and only one platform. It works fine on others. Don't blame the
> > driver, stop it in PCI.
> 
> How sure are you that it's only those Sony laptops?
> 

I do not underestimate the ability of BIOS writers to
screw things up.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
