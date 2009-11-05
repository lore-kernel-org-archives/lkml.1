Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZKEQEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZKEQEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZKEQEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:04:38 -0500
Received: from build.ossfans.org ([67.223.233.67]:54278 "EHLO
	build.ossfans.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZKEQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:04:38 -0500
X-Greylist: delayed 817 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 11:04:38 EST
Date: Thu, 5 Nov 2009 18:50:58 +0300
From: Sergey Lapin <slapin@ossfans.org>
To: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Brownell <david-b@pacbell.net>
Subject: mcp23008, gpio chip
Message-ID: <20091105155058.GA7524@build.ossfans.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

In my development board, which ix custom and based on PXA270,
I have GPIO extender chip mcp23008, which is I2C-based and 8-bit wide.
I see drivers/gpio/mcp23s08.c, which is a driver for SPI
version of this chip.

Is there any ongoing work on making a driver for I2C part?

All the best,
S.

