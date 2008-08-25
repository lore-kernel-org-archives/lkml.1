Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYHYWFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYHYWFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYHYWFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:05:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:58644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYHYWFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:05:23 -0400
Date: Mon, 25 Aug 2008 15:05:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] use lspci style for [%04x:%04x] vendor/device
Message-ID: <20080825150525.6f1b5706@infradead.org>
In-Reply-To: <20080825220137.19210.41857.stgit@tigger.helgaas>
References: <20080825220137.19210.41857.stgit@tigger.helgaas>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008 16:01:38 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> These patches change various debug messages to use "[%04x:%04x]" for
> PCI vendor/device IDs to follow the format used by lspci(8).

I hope you're adding a new whicked special format specifier for this
... taking a PCI dev struct as argument.

That's be really nice to have;-)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
