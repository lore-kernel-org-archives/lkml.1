Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZFAQes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZFAQes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZFAQek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:34:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZFAQej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:34:39 -0400
Date: Mon, 1 Jun 2009 13:34:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Paulraj, Sandeep" <s-paulraj@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Grosen, Mark" <mgrosen@ti.com>
Subject: Re: New Driver for DaVinci DM355/DM365/DM6446
Message-ID: <20090601133436.06a4a4a0@pedra.chehab.org>
In-Reply-To: <C9D59C82B94F474B872F2092A87F261481797D4B@dlee07.ent.ti.com>
References: <C9D59C82B94F474B872F2092A87F261481797D4B@dlee07.ent.ti.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 1 Jun 2009 09:56:40 -0500
"Paulraj, Sandeep" <s-paulraj@ti.com> escreveu:

> 
> Hello,
> 
> WE have a module(H3A) on Davinci DM6446,DM355 and DM365.
> 
> Customers require a way to collect the data required to perform the Auto Exposure (AE), Auto Focus(AF), and Auto White balance (AWB) in hardware as opposed to software. This is primarily for performance reasons as there is not enough software processing MIPS (to do 3A statistics) available in
> an imaging/video system.
> 
> Including this block in hardware reduces the load on the processor and bandwidth to the memory as the data is collected on the fly from the imager.
> 
> This modules collects statistics and we currently implement it as a character driver.
> 
> Which mailing list would be the most appropriate mailing list to submit patches for review?

You should send they to:
	LMML <linux-media@vger.kernel.org>

If you are proposing API changes, please submit they first.

> 
> Thanks,
> Sandeep
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
