Return-Path: <linux-kernel-owner+w=401wt.eu-S1764941AbXGXSRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764941AbXGXSRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXGXSRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:17:39 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3204 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764711AbXGXSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:17:38 -0400
Date: Tue, 24 Jul 2007 19:17:36 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       =?ISO-8859-15?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
In-Reply-To: <46A63BC3.3050208@garzik.org>
Message-ID: <Pine.LNX.4.64N.0707241914060.17807@blysk.ds.pg.gda.pl>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
 <200707240948.45916.bjorn.helgaas@hp.com> <46A63BC3.3050208@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Jeff Garzik wrote:

> It seems clear from this report that we cannot, should not, trust BIOS for
> something (a) so simple and (b) that has been working for over a decade.

 And (c) something BIOS writers have never ever in their most unlikely 
imagination expected to be trusted for.

  Maciej
