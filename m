Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXL1IbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXL1IbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 03:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXL1IbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 03:31:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXL1IbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 03:31:02 -0500
Date: Fri, 28 Dec 2007 16:27:08 +0800 (CST)
Message-Id: <20071228.162708.2084627001.qcai@redhat.com>
To: oliver@linux-kernel.at
Cc: linux-kernel@vger.kernel.org, qcai@redhat.com
Subject: Re: kernel panic - help!?
From: Cai Qian <qcai@redhat.com>
In-Reply-To: <4774A774.8020404@linux-kernel.at>
References: <a8e1da0712120156v2b855f64jf40f9971ebf9b689@mail.gmail.com>
	<20071212142436.GB16664@bleen.domain.actdsltmp>
	<4774A774.8020404@linux-kernel.at>
X-mailer: Mew/5.2.51 Emacs/22.1.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From: Oliver Falk <oliver@linux-kernel.at>
Subject: Re: kernel panic - help!?
Date: Fri, 28 Dec 2007 08:36:20 +0100

> On 12/12/2007 03:24 PM, Justin Banks wrote:
> > Dave Young wrote
> >> On Dec 12, 2007 5:17 PM, Oliver Falk <oliver@linux-kernel.at> wrote:
> >>> Can someone explain me that?
> >>>
> >>> Dec 12 00:24:15 santorini kernel: Unable to handle kernel NULL pointer
> >>> dereference at virtual address 00000000
> >>> Dec 12 00:24:15 santorini kernel:  printing eip:
> >>> Dec 12 00:24:15 santorini kernel: c0190182
> >>> Dec 12 00:24:15 santorini kernel: *pde = 1b62b001
> >>> Dec 12 00:24:15 santorini kernel: Oops: 0000 [#1]
> >>> Dec 12 00:24:15 santorini kernel: SMP
> >>> Dec 12 00:24:15 santorini kernel: Modules linked in: mptctl mptbase sg
> >>> md5 ipv6 i2c_dev i2c_core button battery ac uhci_hcd ehci_hcd hw_rand
> >>> om tg3 bonding(U) floppy ata_piix libata dm_snapshot dm_zero dm_mirror
> >>> ext3 jbd dm_mod cciss sd_mod scsi_mod
> >>> Dec 12 00:24:15 santorini kernel: CPU:    2
> >>> Dec 12 00:24:15 santorini kernel: EIP:    0060:[<c0190182>]    Not
> >>> tainted VLI
> >>> Dec 12 00:24:15 santorini kernel: EFLAGS: 00010246   (2.6.9-55.0.9.ELsmp)
> > 
> > ----------------------------------------------------------^^^^^^^^^^^^^^^^^^
> > 
> > <snip>
> > 
> > 
> >> Please tell the kernel version before post.
> > 
> > It's really really old :)
> 
> of@santorini:~$ uname -r
> 2.6.9-55.0.9.ELsmp
> 
> Some RHEL system....
> 

Probably worth trying the latest RHEL4U5 kernel 2.6.9-55.0.14.EL.

CQ

> -of
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
