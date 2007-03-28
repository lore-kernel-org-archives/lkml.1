Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXC1Kcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXC1Kcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 06:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXC1Kcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 06:32:46 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2222 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbXC1Kcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 06:32:45 -0400
Date: Wed, 28 Mar 2007 11:32:39 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org
Subject: Re: [CHAR] Wire up DEC serial drivers in Kconfig
In-Reply-To: <20070328023724.GA31980@linux-mips.org>
Message-ID: <Pine.LNX.4.64N.0703281128010.25992@blysk.ds.pg.gda.pl>
References: <20070328023724.GA31980@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Ralf Baechle wrote:

> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 I'm not sure it's worth the hassle -- I'm in the middle of moving the 
driver to drivers/serial/, which I should finish soon after I reestablish 
my home network.  Otherwise I'm fine with it.  Has anybody actually 
requested it?

  Maciej
