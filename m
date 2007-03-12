Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbXCLXTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbXCLXTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXCLXTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:19:08 -0400
Received: from ozlabs.org ([203.10.76.45]:43320 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbXCLXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:19:07 -0400
Subject: CONFIG_REORDER Kconfig help strange sentence.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 10:18:03 +1100
Message-Id: <1173741484.10618.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this confused me:

        Function reordering (REORDER) [N/y/?] (NEW) ?
        
        This option enables the toolchain to reorder functions for a more 
        optimal TLB usage. If you have pretty much any version of binutils, 
        this can increase your kernel build time by roughly one minute.
        
"If you have pretty much any version of binutils"?  Huh?

You mean "This will slow your kernel build by about a minute"?

Rusty.

