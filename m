Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXKEXZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXKEXZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXKEXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:24:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52065
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754459AbXKEXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:24:52 -0500
Date: Mon, 05 Nov 2007 15:24:51 -0800 (PST)
Message-Id: <20071105.152451.260321864.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0711051432531.15101@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
	<20071105221752.GA9509@suse.de>
	<alpine.LFD.0.999.0711051432531.15101@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Nov 2007 14:37:31 -0800 (PST)

> So let me one more say:
> 
>  - don't just say 
> 
> 	.. was cured by commit xyz
> 
>  - but add the one-liner description of the commit, something along the 
>    lines of
> 
> 	.. was cured by commit xyz ("PCI: Add quirk for devices which 
>         disable MSI when INTX_DISABLE is set.")
> 
> so that the commit messages are readable even outside git.

I agree, and I've been trying to get into the habit of
doing this even though I didn't this time.
