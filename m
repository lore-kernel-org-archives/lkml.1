Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907Ab0ACU6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0ACU6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 15:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299Ab0ACU6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 15:58:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54056 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0ACU6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 15:58:39 -0500
Date: Sun, 3 Jan 2010 20:58:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dan Carpenter <error27@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] off by one bug
Message-ID: <20100103205836.GA7765@sirena.org.uk>
References: <20100103120817.GA19360@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100103120817.GA19360@bicker>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 03, 2010 at 02:08:17PM +0200, Dan Carpenter wrote:
> If irq == WM8350_NUM_IRQ that would put us past the end of the array.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but please take a look at the advice in Documentation/SubmittingPatches
about picking a title for your patch, with the one you've got it's not
even clear which subsystem you're talking about never mind which driver.
