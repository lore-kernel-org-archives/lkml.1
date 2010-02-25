Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab0BYPst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:48:49 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:20507 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013Ab0BYPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:48:48 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: pci: Prevent mmconfig memory corruption
Date: Thu, 25 Feb 2010 08:48:20 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>
References: <alpine.LFD.2.00.1002251638230.4245@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002251638230.4245@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002250848.21180.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 February 2010 08:42:11 am Thomas Gleixner wrote:
> commit ff097ddd4 (x86/PCI: MMCONFIG: manage pci_mmcfg_region as a
> list, not a table) introduced a nasty memory corruption when
> pci_mmcfg_list is empty.

Ouch, I'm really sorry about that.  Thanks for fixing it.

Bjorn
