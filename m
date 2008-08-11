Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbYHKWIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbYHKWIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYHKWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:08:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46128 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbYHKWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:08:07 -0400
Date: Mon, 11 Aug 2008 23:06:38 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [WATCHDOG] v2.6.27-rc watchdog fixes
Message-ID: <20080811220638.GC21967@flint.arm.linux.org.uk>
References: <20080810204527.GF2773@infomag.infomag.iguana.be> <20080810213520.GA2847@flint.arm.linux.org.uk> <20080811183604.GA26249@infomag.infomag.iguana.be> <20080811184049.GB21967@flint.arm.linux.org.uk> <20080811205124.GB26249@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811205124.GB26249@infomag.infomag.iguana.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 10:51:24PM +0200, Wim Van Sebroeck wrote:
> Hi Russell,
> 
> > It's in part of my general ARM updates, and I combined Adrian's three
> > patches together, along with the remaining bits from my s3c2410 patch.
> > Here's the mbox mail corresponding with the commit:
> 
> Applied the patch together with Ben's previously issued patches.
> We now have these Changes (Ben can you test also?):

Okay, but this means I'll need to kick that commit out of my git
tree, or maybe just leave it and let git handle the merge.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
