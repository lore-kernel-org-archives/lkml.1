Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYKZUIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYKZUIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYKZUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:08:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1980 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYKZUI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:08:28 -0500
Date: Wed, 26 Nov 2008 20:08:25 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@openedhand.com>, lkml <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [patch 2.6.28-rc6 2/3] mfd: twl4030: cleanup symbols and OMAP dependency
Message-ID: <20081126200823.GL6234@sirena.org.uk>
References: <200811261058.12061.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811261058.12061.david-b@pacbell.net>
X-Cookie: I smell a wumpus.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 10:58:11AM -0800, David Brownell wrote:

> This lets the TWL4030 code be included in test builds for most
> platforms, and will make it easier for non-OMAP folk to update
> most of this code for new APIs etc.

Excellent, thanks!
