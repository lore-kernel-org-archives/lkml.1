Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZENPlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZENPlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZENPlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:41:21 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:58821 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZENPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:41:20 -0400
Date: Thu, 14 May 2009 11:41:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/acpi: remove compress irq trick for 32bit
In-reply-to: <49F4D7CB.4040406@kernel.org>
Message-id: <alpine.LFD.2.00.0905141140000.19537@localhost.localdomain>
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu>
 <49E802CE.5030406@kernel.org> <49E80457.5060403@kernel.org>
 <alpine.LFD.2.00.0904230039420.21119@localhost.localdomain>
 <49F4D7CB.4040406@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,
I'm really happy to see this workaround finally get removed.

Acked-by: Len Brown <len.brown@intel.com>

Ingo,
go ahead and keep this with your irq patches.

thanks,
Len Brown, Intel Open Source Technology Center

