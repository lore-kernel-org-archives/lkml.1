Return-Path: <linux-kernel-owner+w=401wt.eu-S965262AbXBUALP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965262AbXBUALP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965030AbXBUALP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:11:15 -0500
Received: from khc.piap.pl ([195.187.100.11]:51770 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262AbXBUALO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:11:14 -0500
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>
	<20070218155445.GV7584@csclub.uwaterloo.ca>
	<45D87BA2.9020001@xs4all.nl>
	<20070218193901.GN7582@csclub.uwaterloo.ca>
	<45D9BDBF.8040405@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
	<45DA7643.4020305@xs4all.nl> <m33b505zez.fsf@maximus.localdomain>
	<20070220215103.GB22464@csclub.uwaterloo.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 21 Feb 2007 01:11:12 +0100
In-Reply-To: <20070220215103.GB22464@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Tue, 20 Feb 2007 16:51:03 -0500")
Message-ID: <m3ps844bfj.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> Via has a dual pci-ext card.  See EXT-PCI at
> http://www.via.com.tw/en/products/mainboards/accessories.jsp

Right, and they say it's compatible with "EPIA mini-ITX family".
That means the mappings I just outlined should apply to all of them.

BTW: any "universal" dual+ PCI riser card have to use a PCI bridge
chip, and a bridge isn't a small 20 pin IC (I'd expect 144 pins or
so). "Active" or "passive" - doesn't matter.
-- 
Krzysztof Halasa
