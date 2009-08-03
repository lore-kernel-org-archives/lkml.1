Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZHCLdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZHCLdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZHCLdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:33:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44942 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZHCLdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:33:24 -0400
Date: Mon, 3 Aug 2009 12:33:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] regulator: Add GPIO enable control to fixed voltage
	regulator driver
Message-ID: <20090803113324.GC5959@sirena.org.uk>
References: <quadros.roger@gmail.com> <1249232208-22274-1-git-send-email-quadros.roger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249232208-22274-1-git-send-email-quadros.roger@gmail.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 07:56:48PM +0300, Roger Quadros wrote:

> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver for regulator enable/disable control.
> The GPIO number and polarity information is passed through platform data.
> GPIO enable control is achieved using gpiolib.

> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>

I'm OK with this apart from the issue Philipp pointed out.
