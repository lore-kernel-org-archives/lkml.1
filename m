Return-Path: <linux-kernel-owner+w=401wt.eu-S1751271AbZDWEmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbZDWEmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 00:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZDWEmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 00:42:24 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:38647 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDWEmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 00:42:23 -0400
Date: Thu, 23 Apr 2009 00:42:05 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Tony Luck <tony.luck@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 6/9] irq: make io_apic_set_pci_routing to take device
In-reply-to: <49E80457.5060403@kernel.org>
Message-id: <alpine.LFD.2.00.0904230039420.21119@localhost.localdomain>
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu>
 <49E802CE.5030406@kernel.org> <49E80457.5060403@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

re: touching ACPI files in this patch with no material effect

Acked-by: Len Brown <len.brown@intel.com>

