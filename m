Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYDAUjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYDAUjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbYDAUjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:39:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:37072 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbYDAUje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:39:34 -0400
Subject: Re: +
	revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch added to
	-mm tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, davem@davemloft.net,
       greg@kroah.com, m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
In-Reply-To: <200804010957.16459.bjorn.helgaas@hp.com>
References: <200803282348.m2SNmleP016847@imap1.linux-foundation.org>
	 <200804010957.16459.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 07:37:56 +1100
Message-Id: <1207082276.10388.224.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-01 at 09:57 -0600, Bjorn Helgaas wrote:
> 
> Can we just drop the "revert gregkh" patches for x86, alpha, powerpc,
> and ia64?

Considering that the generic is equivalent to what I have today on
powerpc, I'm fine with it.

Cheers,
Ben.


