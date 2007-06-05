Return-Path: <linux-kernel-owner+w=401wt.eu-S1765032AbXFETTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765032AbXFETTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760242AbXFETTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:19:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59373
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbXFETTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:19:05 -0400
Date: Tue, 05 Jun 2007 12:19:18 -0700 (PDT)
Message-Id: <20070605.121918.63995208.davem@davemloft.net>
To: michal.k.k.piotrowski@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com, mikem@beardog.cca.cpqcorp.net, tom.l.nguyen@intel.com,
       linux-ide@vger.kernel.org, lethal@linux-sh.org, htejun@gmail.com,
       jeff@garzik.org, alan@redhat.com, sparclinux@vger.kernel.org,
       vonbrand@inf.utfsm.cl
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches
From: David Miller <davem@davemloft.net>
In-Reply-To: <4665792B.8030005@googlemail.com>
References: <46657866.7000108@googlemail.com>
	<4665792B.8030005@googlemail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: Tue, 05 Jun 2007 16:54:35 +0200

> Sparc64
> 
> Subject    : arch/sparc64/time.c doesn't compile on Ultra 1 (no PCI)
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8540
> Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
> Status     : patch available

This patch is in Linus's tree.
