Return-Path: <linux-kernel-owner+w=401wt.eu-S934468AbZKYKKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468AbZKYKKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZKYKKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:10:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58464 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbZKYKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:10:07 -0500
Date: Wed, 25 Nov 2009 10:10:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] twl4030: fix ELF section mismatch...
Message-ID: <20091125101011.GA30207@sirena.org.uk>
References: <6278d2220911231054r15891be8k8f8130fd47cddca2@mail.gmail.com> <20091124233754.GK8290@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124233754.GK8290@sortiz.org>
X-Cookie: There is a 20% chance of tomorrow.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 12:37:55AM +0100, Samuel Ortiz wrote:
> On Mon, Nov 23, 2009 at 06:54:06PM +0000, Daniel J Blueman wrote:
> > Since twl4030_probe is only called from functions in the init ELF
> > section, annotate it so.
> > 
> > Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

> Mark, thanks for carrying this one with your twl4030 branch.

Sure.  Daniel, could you please resend the patch to me - I've deleted
the original.
