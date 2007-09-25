Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbXIYJpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbXIYJpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXIYJoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:44:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51232 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071AbXIYJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:44:54 -0400
Date: Tue, 25 Sep 2007 10:50:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       roel <12o3l@tiscali.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/2] Enable link power management for ata drivers
Message-ID: <20070925105025.0cb9cc37@the-village.bc.nu>
In-Reply-To: <46F84F45.6000807@pobox.com>
References: <20070924215140.966161778@intel.com>
	<20070924151320.67f0c332.kristen.c.accardi@intel.com>
	<46F84460.5090703@tiscali.nl>
	<20070924164118.803cfb22.kristen.c.accardi@intel.com>
	<46F84F45.6000807@pobox.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It converts several macros to inline functions (encouraged), and also 
> illustrates a nice, clean way of testing an ID word's validity. 
> [obviously the final implementation varies, depending on that ID word's 
> history]

Its in -mm and I thought you put a copy in your tree after I said it
hadn't upset anything in -mm ?

Alan
