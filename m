Return-Path: <linux-kernel-owner+w=401wt.eu-S1946001AbXBBRpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946001AbXBBRpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 12:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946002AbXBBRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 12:45:10 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:49503 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946001AbXBBRpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 12:45:09 -0500
Date: Fri, 2 Feb 2007 18:41:02 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Paul Rolland <rol@as2917.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
In-Reply-To: <20070202085351.3215815f.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0702021840370.24408@yvahk01.tjqt.qr>
References: <011601c746d9$dc5453b0$4b00a8c0@donald>
 <Pine.LNX.4.61.0702021610510.26531@yvahk01.tjqt.qr>
 <20070202085351.3215815f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2 2007 08:53, Randy Dunlap wrote:
>
>if (MODULE_LICENSE_contains_null(license))
>	printk(KERN_WARNING "this module's license is suspicious\n");

Try to code that macro.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
