Return-Path: <linux-kernel-owner+w=401wt.eu-S1764901AbZFQHY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764901AbZFQHY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZFQHYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:24:48 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:47237 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbZFQHYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:24:47 -0400
Date: Wed, 17 Jun 2009 08:24:13 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: mips tree build failure
Message-ID: <20090617072413.GA13467@linux-mips.org>
References: <20090617163549.84cfc4b6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617163549.84cfc4b6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 04:35:49PM +1000, Stephen Rothwell wrote:

> Yesterday's linux-next build (mips defconfig) failed like this:
> 
> arch/mips/lib/delay.c:54: error: 'us' undeclared (first use in this function)
> 
> Caused by commit 5636919b5c909fee54a6ef5226475ecae012ad02 ("MIPS: Outline
> udelay and fix a few issues") which is now in Linus' tree (sorry I didn't
> report it earlier).

This is already fixed and will go upstream with my next pull request.

Thanks for reporting!

  Ralf
