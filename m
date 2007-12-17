Return-Path: <linux-kernel-owner+w=401wt.eu-S1764109AbXLQV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764109AbXLQV0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbXLQV0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:26:08 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9039 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbXLQV0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:26:07 -0500
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 16:26:07 EST
Message-Id: <20071217210937.103111394@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Dec 2007 14:09:37 -0700
From: bjorn.helgaas@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz
Subject: [patch 0/3] use dev_printk in PCI quirks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes here; these only use dev_printk when possible.
In a few cases, I tweaked message wordings to make them more consistent.
--
