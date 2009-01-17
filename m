Return-Path: <linux-kernel-owner+w=401wt.eu-S1763765AbZAQQIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763765AbZAQQIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760569AbZAQQI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:08:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4711 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZAQQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:08:27 -0500
Date: Sat, 17 Jan 2009 16:08:19 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: rpurdie@rpsys.net, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090117160819.GB7210@sirena.org.uk>
References: <4971F400.4070701@gmail.com> <20090117160519.GA7210@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117160519.GA7210@sirena.org.uk>
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

On Sat, Jan 17, 2009 at 04:05:32PM +0000, Mark Brown wrote:

> but it probably ought to get pushed out via MFD - I'll send it along to
> Samuel.

Eh, sorry - I meant regulator and Liam
