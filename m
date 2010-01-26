Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752Ab0AZHUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0AZHUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584Ab0AZHUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:20:16 -0500
Received: from jgarrett.org ([64.5.53.252]:40686 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0AZHUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:20:15 -0500
Date: Tue, 26 Jan 2010 01:19:12 -0600
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100126071912.GA7543@jgarrett.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
 <hE3x9c-4KZM.A.tpF.EKMXLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hE3x9c-4KZM.A.tpF.EKMXLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: jeff@jgarrett.org (Jeff Garrett)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:04:38PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15124
> Subject		: PCI host bridge windows ignored (works with pci=use_crs)
> Submitter	: Jeff Garrett <jeff@jgarrett.org>
> Date		: 2010-01-13 5:37 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=126336296600307&w=4
> Handled-By	: Yinghai Lu <yinghai@kernel.org>
> 		  Bjorn Helgaas <bjorn.helgaas@hp.com>

This regression should still be listed.  No patch to test yet.

-Jeff Garrett
