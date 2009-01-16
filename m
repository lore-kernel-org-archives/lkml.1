Return-Path: <linux-kernel-owner+w=401wt.eu-S936883AbZAPT5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936883AbZAPT5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZAPT5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:57:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:52285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZAPT5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:57:01 -0500
Subject: Re: Compile error in drivers/video/backlight/mbp_nvidia_bl.c -
 v2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: Martin Koegler <mkoegler@auto.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090116080503.GA11855@auto.tuwien.ac.at>
References: <20090116080503.GA11855@auto.tuwien.ac.at>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 18:14:25 +0000
Message-Id: <1232129665.25018.8490.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 09:05 +0100, Martin Koegler wrote:
> 
>   CC [M]  drivers/video/backlight/mbp_nvidia_bl.o
> drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage size of
> `__mod_dmi_device_table' isn't known

Hm, didn't we already have a patch to fix this? Is it fixed in
2.6.29-rc1, or did we drop the patch?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

