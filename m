Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXBTRiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXBTRiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932802AbXBTRiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:38:03 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:32796 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbXBTRiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:38:01 -0500
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 12:38:01 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17883.2878.998312.904061@jfsnew.stoffel.org>
Date: Tue, 20 Feb 2007 09:52:46 -0500
From: "John Stoffel" <john@stoffel.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Artem> This patch-set contains UBI, which stands for Unsorted Block
Artem> Images. This is closely related to the memory technology
Artem> devices Linux subsystem (MTD), so this new piece of software is
Artem> from drivers/mtd/ubi.

Can you define UBI in each and every file you create?  This is a
completely unique acronym and I'm sure a bunch of people will be going
"wtf" when they read this, I know I was.  

Artem> In short, UBI is kind of LVM layer but for flash (MTD)
Artem> devices. It makes it possible to dynamically create, delete and
Artem> re-size volumes. But the analogy is not full. UBI also takes
Artem> care of wear-leveling and bad eraseblocks handling, so UBI
Artem> completely hides 2 aspects of flash chips which make them very
Artem> difficult to work with:

Neat stuff!  Too bad you don't have a more descriptive name for it,
UBI just doesn't seem to have any connection to LVM for Flash plus
wear leveling.  

/grin/

John
