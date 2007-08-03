Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbXHCISH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbXHCISH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 04:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXHCIRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 04:17:51 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:20560 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554AbXHCIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 04:17:49 -0400
Message-ID: <46B2E49E.6080103@interia.pl>
Date: Fri, 03 Aug 2007 10:17:34 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: Makefile fix (was Re: [PATCH] mtdsuper: licensce
 = GPL)
References: <46B0D1F7.9090805@interia.pl> <alpine.LFD.0.999.0708020318070.8258@enigma.security.iitk.ac.in> <46B18551.2020809@interia.pl> <alpine.LFD.0.999.0708021309430.8258@enigma.security.iitk.ac.in> <46B1FFFB.6040209@interia.pl> <alpine.LFD.0.999.0708030811330.23798@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708030811330.23798@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 76f92acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH] mtd: Makefile fix
> 
> We want drivers/mtd/{mtdcore, mtdsuper, mtdpart}.c to be built and linked
> into the same mtd.ko module. Fix the Makefile to ensure this, and remove
> duplicate MODULE_ declarations in mtdpart.c, as mtdcore.c already has them.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Ok. I have mtd.ko now.

Thank You
Rafa³


----------------------------------------------------------------------
Wszystko czego potrzebujesz latem: kremy do opalania, 
stroje kapielowe, maly romans 

>>>http://link.interia.pl/f1b15

