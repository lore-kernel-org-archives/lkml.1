Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXA2XEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXA2XEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXA2XEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:04:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbXA2XEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:04:15 -0500
Date: Mon, 29 Jan 2007 15:04:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
In-Reply-To: <20070129144055.151cfe52@freekitty>
Message-ID: <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
 <1169931333.17469.125.camel@localhost.localdomain> <20070129113159.7ad22e4c@freekitty>
 <1170101430.29240.34.camel@localhost.localdomain> <20070129133849.1b523226@freekitty>
 <1170109401.29240.49.camel@localhost.localdomain>
 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
 <20070129144055.151cfe52@freekitty>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jan 2007, Stephen Hemminger wrote:
> 
> MSI works fine for almost all systems (except AMD systems where
> MSI is broken for ALL devices).

Why do you ignore reality?

MSI does *not* work fine, exactly because the firmware screws it up.

The fact that on a "hardware level" it may work is totally irrelevant. The 
*only* thing that matters is what people actually see.

"Positivism" may not be a hot philosophy these days any more, but dang, it 
certainly is better than what you seem to espouse: "in theory things work 
fine".

And if you don't like positivism, how about just simple scientific method: 
a theory is *proven*wrong* by a single observation to the opposite. And we 
have several people standing up saying that your theory is wrong.

		Linus
