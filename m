Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZE1KSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZE1KSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZE1KSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:18:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36419 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZE1KSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:18:10 -0400
Date: Thu, 28 May 2009 11:14:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, scottwood@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       timur@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528101440.GB14789@n2100.arm.linux.org.uk>
References: <20090527175609.GB31861@flint.arm.linux.org.uk> <1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk> <20090528.025739.16559619.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528.025739.16559619.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 02:57:39AM -0700, David Miller wrote:
> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Thu, 28 May 2009 10:15:13 +0100
> 
> > For example, how would an IrDA transceiver be expressed in OF?
> 
> As a child device node of the IRDA device, with associated
> properties.
> 
> You can express _ANYTHING_ using the OF device tree.  It is
> not even something to discuss, it's flexible enough.

That's not a useful reply.  I'm trying to discuss specifics and find out
_precisely_ how they would be handled in an OF-based situation.  You're
attitude in this discussion is really not helping, and is actually
insulting.

If you have anything _usefully_ technical to contribute then please do.
Otherwise, shut up.
