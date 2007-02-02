Return-Path: <linux-kernel-owner+w=401wt.eu-S1946003AbXBBRzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946003AbXBBRzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 12:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946004AbXBBRzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 12:55:22 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:63123 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946003AbXBBRzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 12:55:21 -0500
Date: Fri, 2 Feb 2007 09:49:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Paul Rolland <rol@as2917.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
Message-Id: <20070202094900.d8931dbe.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0702021840370.24408@yvahk01.tjqt.qr>
References: <011601c746d9$dc5453b0$4b00a8c0@donald>
	<Pine.LNX.4.61.0702021610510.26531@yvahk01.tjqt.qr>
	<20070202085351.3215815f.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0702021840370.24408@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 18:41:02 +0100 (MET) Jan Engelhardt wrote:

> 
> On Feb 2 2007 08:53, Randy Dunlap wrote:
> >
> >if (MODULE_LICENSE_contains_null(license))
> >	printk(KERN_WARNING "this module's license is suspicious\n");
> 
> Try to code that macro.

It's not a macro afaict.

---
~Randy
