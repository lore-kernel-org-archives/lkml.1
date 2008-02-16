Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbYBPAqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbYBPAqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYBPAp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:45:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50674 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625AbYBPAp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:45:57 -0500
Date: Fri, 15 Feb 2008 16:45:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080215164543.e8a808ba.akpm@linux-foundation.org>
In-Reply-To: <20080216003136.GG31474@flint.arm.linux.org.uk>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080216000943.GD31474@flint.arm.linux.org.uk>
	<20080215162121.317c7c1c.akpm@linux-foundation.org>
	<20080216003136.GG31474@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 00:31:36 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> > so would a stupid `for i in arch/arm/configs/*' script be sufficient
> > coverage?
>
> It will certainly improve the situation significantly, and pick up
> on some non-ARM problems like (badge4_defconfig, since 2.6.24-git2):

OK, I'll toss something together.

>  the latter seems to be because the PCMCIA changes were lost
> on the linux-pcmcia list and the trizeps folk have probably given up.

I appear to be pcmcia maintainer lately so if someone wants to dust them
off and send them over we can see what we can do?
