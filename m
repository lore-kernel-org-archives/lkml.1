Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbZAQQFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbZAQQFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZAQQFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:05:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4688 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbZAQQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:05:43 -0500
Date: Sat, 17 Jan 2009 16:05:32 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: rpurdie@rpsys.net, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090117160519.GA7210@sirena.org.uk>
References: <4971F400.4070701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4971F400.4070701@gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] leds: Fix bounds checking of wm8350->pmic.led
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 04:06:40PM +0100, Roel Kluin wrote:
> Fix bounds checking of wm8350->pmic.led

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but it probably ought to get pushed out via MFD - I'll send it along to
Samuel.
