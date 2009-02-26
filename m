Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZBZUZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZBZUZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZBZUZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:25:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3343 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZBZUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:25:26 -0500
Date: Thu, 26 Feb 2009 20:25:23 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch/rfc 2.6.29-rc6 2/2] regulator: twl4030 voltage
	enumeration (v2)
Message-ID: <20090226202516.GF8595@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902231245.44360.david-b@pacbell.net> <200902231254.13990.david-b@pacbell.net> <200902261150.15125.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902261150.15125.david-b@pacbell.net>
X-Cookie: My haircut is totally traditional!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 11:50:14AM -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>

> Update previously-posted twl4030 regulator driver to export
> supported voltages to upper layers using a new mechanism.

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Looks good, thanks!

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

