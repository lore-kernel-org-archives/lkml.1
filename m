Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZICPVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZICPVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZICPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:21:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53693 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbZICPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:21:08 -0400
Date: Thu, 3 Sep 2009 16:21:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Russell King <linux@arm.linux.org.uk>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] U300 AB3100 boardinfo v4
Message-ID: <20090903152102.GF2954@sirena.org.uk>
References: <1251982409-24055-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251982409-24055-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: A mushroom cloud has no silver lining.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 02:53:29PM +0200, Linus Walleij wrote:
> This defines regulator platform data and board power
> regulator hogs for the ST-Ericsson U300 platform.

> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though vext looks like that supply could be dropped too.
