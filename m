Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbXJETYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbXJETYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbXJETYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:24:06 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42463 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759298AbXJETYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:24:05 -0400
Date: Fri, 5 Oct 2007 15:24:04 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
Message-ID: <20071005192404.GB4003@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr> <20071005191940.GA4003@csclub.uwaterloo.ca> <Pine.LNX.4.64.0710052120270.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710052120270.13406@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 09:21:57PM +0200, Jan Engelhardt wrote:
> Indeed it should be 0x07, should it go in.
> Otherwise the openbsd camp might start another flamewar.
> 
> (On a personal note, would 0x1F work better for you?)

No, I actually find most things hard to read on a blue background.
Besides black uses less power on a CRT (and probably OLED as well)
monitor.  LCDs probably don't care.  :)

--
Len Sorensen
