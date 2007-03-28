Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbXC1DZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbXC1DZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 23:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933430AbXC1DZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 23:25:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41983 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbXC1DZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 23:25:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 3/21] MSI: Simplify BUG() handling in msi_remove_pci_irq_vectors() part 1
References: <20070322105332.9F22BDDF52@ozlabs.org>
Date: Tue, 27 Mar 2007 21:24:33 -0600
In-Reply-To: <20070322105332.9F22BDDF52@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:31 +1100")
Message-ID: <m1lkhit5hq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> Although it might be nice to do a printk before BUG'ing, it's really not
> necessary, and it complicates the code.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
