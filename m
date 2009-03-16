Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZCPPvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZCPPvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZCPPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:51:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1676 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZCPPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:51:08 -0400
Date: Mon, 16 Mar 2009 15:51:04 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: dbrownell@users.sourceforge.net
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, OMAP <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch] twl4030-regulator: expose VPLL2
Message-ID: <20090316155103.GJ16539@sirena.org.uk>
References: <200903131754.54997.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903131754.54997.david-b@pacbell.net>
X-Cookie: Security check:  =?ISO-8859-1?Q?=20=07=07=07INTRUDER?= ALERT!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 05:54:54PM -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Add VPLL2 to the set of twl4030-family regulators exposed for
> use by various drivers.  It's commonly used to power the digital
> video outputs (e.g. LCD or DVI displays) on OMAP3 systems.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
