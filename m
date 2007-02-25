Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXBYFsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXBYFsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbXBYFsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:48:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbXBYFsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:48:05 -0500
Date: Sun, 25 Feb 2007 05:48:03 +0000
From: Christoph Hellwig <hch@infradead.org>
To: John Stoffel <john@stoffel.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
Message-ID: <20070225054803.GD7941@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	John Stoffel <john@stoffel.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <17883.2878.998312.904061@jfsnew.stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17883.2878.998312.904061@jfsnew.stoffel.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 09:52:46AM -0500, John Stoffel wrote:
> 
> Artem> This patch-set contains UBI, which stands for Unsorted Block
> Artem> Images. This is closely related to the memory technology
> Artem> devices Linux subsystem (MTD), so this new piece of software is
> Artem> from drivers/mtd/ubi.
> 
> Can you define UBI in each and every file you create?  This is a
> completely unique acronym and I'm sure a bunch of people will be going
> "wtf" when they read this, I know I was.  

We're not in kindergarden.  An explanation in Kconfig or the main
header file should be more than enough.

