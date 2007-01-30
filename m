Return-Path: <linux-kernel-owner+w=401wt.eu-S965120AbXA3A0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120AbXA3A0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965137AbXA3A0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:26:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965128AbXA3AZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:25:58 -0500
Date: Mon, 29 Jan 2007 16:25:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
In-Reply-To: <20070129161626.33277eb1@freekitty>
Message-ID: <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
 <1169931333.17469.125.camel@localhost.localdomain> <20070129113159.7ad22e4c@freekitty>
 <1170101430.29240.34.camel@localhost.localdomain> <20070129133849.1b523226@freekitty>
 <1170109401.29240.49.camel@localhost.localdomain>
 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
 <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org>
 <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org>
 <20070129161626.33277eb1@freekitty>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jan 2007, Stephen Hemminger wrote:
> 
> On one and only one platform. It works fine on others. Don't blame the
> driver, stop it in PCI.

How sure are you that it's only those Sony laptops?

		Linus
