Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbXLNOrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbXLNOrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXLNOrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:47:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50408 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbXLNOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:47:13 -0500
Date: Fri, 14 Dec 2007 14:46:28 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-dvb@linuxtv.org, linux-acpi@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [BUG] Kernel Bugs Weekly (maybe bi-weekly)
Message-ID: <20071214144628.GB15149@flint.arm.linux.org.uk>
Mail-Followup-To: Natalie Protasevich <protasnb@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
	linux-pcmcia@lists.infradead.org,
	linux-input@atrey.karlin.mff.cuni.cz, linux-dvb@linuxtv.org,
	linux-acpi@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
References: <32209efe0712132057x247219e0m602f24d1e3a2c20b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32209efe0712132057x247219e0m602f24d1e3a2c20b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:57:24PM -0800, Natalie Protasevich wrote:
> PLATFORM======================================================================
> 
> s3c2440_clk_add disables inactive clocks _ARM_
> http://bugzilla.kernel.org/show_bug.cgi?id=9040
> Kernel: 2.6.22
> ARM, assigned to Ben Dooks (question is if he knows this :)

Not quite sure what the point of putting it in an email he hasn't seen
is either.

Adding Ben as a CC.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
