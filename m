Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZFARJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZFARJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZFARJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:09:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33233 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZFARJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:09:06 -0400
Date: Mon, 1 Jun 2009 18:08:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for
	post-2.6.30
Message-ID: <20090601170856.GF16580@n2100.arm.linux.org.uk>
References: <20090526220517.25381.75976.stgit@localhost.localdomain> <20090601165623.GB4825@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601165623.GB4825@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 09:56:24AM -0700, Tony Lindgren wrote:
> * Paul Walmsley <paul@pwsan.com> [090526 15:27]:
> > Hello Russell,
> > 
> > here is the next set of OMAP clock patches for review for the
> > post-2.6.30 merge window.  They apply on top of the previous set
> > ("OMAP clock/SDRC patches on v2.6.30-rc5").  If you're happy with
> > these patches, Tony will queue them up into his for-next branch.
> 
> Looks like Russell now has all the omap for-next merged to his
> devel branch. Only this series is missing and the omap4 SMP patches.

This series I've avoided looking at due to lack of time.  I only just
got around to sorting through your patches from the last two weeks
last Thursday/Friday, and I've spent Sunday evening and today boot
testing and debugging what's been merged on my LDP platform.

It'll be a week or so before I look at OMAP again.
