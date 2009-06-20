Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZFTOOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZFTOOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFTOOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:14:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46233 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZFTOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:14:34 -0400
Date: Sat, 20 Jun 2009 15:14:01 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Kallsyms problems (was: Re: linux-next: arm build
	failures)
Message-ID: <20090620141401.GA23844@flint.arm.linux.org.uk>
References: <20090617162612.703adfd9.sfr@canb.auug.org.au> <tnx3a9ztg14.fsf@pc1117.cambridge.arm.com> <20090617230804.5e353ec9.sfr@canb.auug.org.au> <20090619151321.GA6223@flint.arm.linux.org.uk> <20090620155440.a7dfb2d4.sfr@canb.auug.org.au> <20090620124152.GI32531@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620124152.GI32531@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 02:41:52PM +0200, Sam Ravnborg wrote:
> Just sent it. Overloaded with day-time stuff (again).

Sam, thanks, it does appear to solve the problem here as well.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
