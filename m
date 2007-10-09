Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbXJIS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbXJIS5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXJIS5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:57:16 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:53018 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbXJIS5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:57:15 -0400
Message-ID: <470BCEFC.9060302@freescale.com>
Date: Tue, 09 Oct 2007 13:57:00 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>	<470691EB.7020209@freescale.com>	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>	<4706A842.9030507@freescale.com>	<20071009174623.GC4003@csclub.uwaterloo.ca>	<470BC0D5.70305@freescale.com> <m3fy0kcec4.fsf@maximus.localdomain>
In-Reply-To: <m3fy0kcec4.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:

> There is no such thing as bit-order.

Yes, there is.  You need to read the article at 
http://www.linuxjournal.com/article/6788.  Explains what it means for bits to 
be in one order versus another.  This is from the perspective of external 
devices, not the CPU (which is always consistent with regards to bit order)


-- 
Timur Tabi
Linux Kernel Developer @ Freescale
