Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXLCOWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXLCOWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXLCOWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:22:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:33058 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbXLCOWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:22:25 -0500
Date: Mon, 3 Dec 2007 08:22:07 -0600
From: Matt Porter <mporter@kernel.crashing.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Vitaly Luban <vitaly@luban.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tokyo Electron SDIO controller (Ellen) support
Message-ID: <20071203142207.GA28101@gate.crashing.org>
References: <47511ADA.20506@luban.org> <20071201215010.2fa3b334@poseidon.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201215010.2fa3b334@poseidon.drzeus.cx>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 09:50:10PM +0100, Pierre Ossman wrote:
> As for the patch, it's a big NAK at this point. Vendors who can't be bothered to follow
> the standard will have to wait for Ben's separation patches before they can be supported.
> Then they can have some voodoo front-end to handle their mistakes instead of turning
> sdhci.c into a collection of hacks and workarounds.

What's the status of Ben's separation patches? I haven't seen a posting of those
versus a recent kernel. I've got some SDHCI driver glue for the non-pci Arasan core
running in an older kernel tree with those patches. It's just waiting for the separation
patches to hit the mmc or mainline tree.

-Matt
