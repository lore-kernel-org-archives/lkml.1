Return-Path: <linux-kernel-owner+w=401wt.eu-S964915AbXBLNvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbXBLNvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964922AbXBLNvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:51:38 -0500
Received: from eazy.amigager.de ([213.239.192.238]:54956 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915AbXBLNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:51:37 -0500
Date: Mon, 12 Feb 2007 14:51:32 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212135132.GA15514@dose.home.local>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <1171147026.19894.16.camel@nigel.suspend2.net> <20070211064636.GA12171@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211064636.GA12171@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 07:46:36 +0100, Willy Tarreau wrote:

[...]

> Many people also have Linux on their notebooks, but as a dual-boot. You
> read the word ? "dual-boot". It means that they cleanly shutdown their
> system every time they don't use it anymore, and they won't know what
> OS they'll use next time.

I can suspend to disk my Mac mini, reboot into MacOS X, shutdown, and
then resume in Linux. I also did this with APM suspend to disk support
on my ThinkPad some years ago, using Linux and Windows.

So, dualboot and suspend support isn't mutual exclusive. This is only
the case if suspend is limited to suspend to RAM.

Regards,
Tino

