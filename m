Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbXLVUFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbXLVUFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXLVUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:05:37 -0500
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:53662 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752810AbXLVUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:05:36 -0500
X-Greylist: delayed 2075 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 15:05:36 EST
Date: Sat, 22 Dec 2007 20:30:58 +0100
From: Martin Mares <mj@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <mj+md-20071222.192526.25019.nikam@ucw.cz>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Just make it so. The name is fine, the concept is unavoidable. The people 
> who complain are whiners that haven't ever had to deal with the fact that 
> there are broken machines around. 

I complain as well as the maintainer of the pciutils. Breaking all userspace
accesses to extended configuration space just because there is a couple
of chipsets which have MMCONFIG messed up is completely unacceptable.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
"This quote has been selected randomly. Really." -- M. Ulrichs
