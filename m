Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZHLXYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZHLXYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZHLXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:24:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60388 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZHLXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:24:51 -0400
Date: Thu, 13 Aug 2009 00:22:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090812232220.GE24667@n2100.arm.linux.org.uk>
References: <4A7ACC8D.7030706@xenontk.org> <20090806124048.GD27773@flint.arm.linux.org.uk> <1249563730.10297.13.camel@Joe-Laptop.home> <20090806133349.GF27773@flint.arm.linux.org.uk> <1249568614.10297.20.camel@Joe-Laptop.home> <20090806150322.GX2080@trinity.fluff.org> <1249948147.8895.96.camel@Joe-Laptop.home> <20090812115520.GI24339@elf.ucw.cz> <20090812194838.GB12117@n2100.arm.linux.org.uk> <1250118277.12423.7.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250118277.12423.7.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 12:04:37AM +0100, Catalin Marinas wrote:
> For the other ARM MAINTAINERS entries (e.g. specific boards), it is up
> to the corresponding maintainers to add whatever lists they want, which
> may include linux-arm@vger.

Just to be clear (and my final email tonight) I don't have a problem
with that, provided the corresponding maintainers do agree (and
therefore provide their ack).

But to do it as a blanket "add linux-arm@vger to everything with
linux-arm-kernel" is wrong.
