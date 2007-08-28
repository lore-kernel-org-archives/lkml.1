Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXH1NMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXH1NMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXH1NM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:12:26 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:33205 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbXH1NMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:12:25 -0400
Date: Tue, 28 Aug 2007 13:11:29 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 06/10] MIPS: cleanup struct irqaction initializers
Message-ID: <20070828121129.GA30532@linux-mips.org>
References: <20070828092927.258417473@linutronix.de>> <20070828092545.990176604@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828092545.990176604@linutronix.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 09:03:01AM -0000, Thomas Gleixner wrote:

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Ralf Baechle <ralf@linux-mips.org>

Queued up for 2.6.24 after fixing a bunch of rejects.

Thanks,

  Ralf
