Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbXLLOcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbXLLOcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXLLOcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:32:41 -0500
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:57267 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753220AbXLLOck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:32:40 -0500
From: Justin Banks <justinb@bakbone.com>
Date: Wed, 12 Dec 2007 07:24:36 -0700
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Oliver Falk <oliver@linux-kernel.at>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic - help!?
Message-ID: <20071212142436.GB16664@bleen.domain.actdsltmp>
References: <475FA716.2000105@linux-kernel.at> <a8e1da0712120156v2b855f64jf40f9971ebf9b689@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712120156v2b855f64jf40f9971ebf9b689@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote
> On Dec 12, 2007 5:17 PM, Oliver Falk <oliver@linux-kernel.at> wrote:
> > Can someone explain me that?
> >
> > Dec 12 00:24:15 santorini kernel: Unable to handle kernel NULL pointer
> > dereference at virtual address 00000000
> > Dec 12 00:24:15 santorini kernel:  printing eip:
> > Dec 12 00:24:15 santorini kernel: c0190182
> > Dec 12 00:24:15 santorini kernel: *pde = 1b62b001
> > Dec 12 00:24:15 santorini kernel: Oops: 0000 [#1]
> > Dec 12 00:24:15 santorini kernel: SMP
> > Dec 12 00:24:15 santorini kernel: Modules linked in: mptctl mptbase sg
> > md5 ipv6 i2c_dev i2c_core button battery ac uhci_hcd ehci_hcd hw_rand
> > om tg3 bonding(U) floppy ata_piix libata dm_snapshot dm_zero dm_mirror
> > ext3 jbd dm_mod cciss sd_mod scsi_mod
> > Dec 12 00:24:15 santorini kernel: CPU:    2
> > Dec 12 00:24:15 santorini kernel: EIP:    0060:[<c0190182>]    Not
> > tainted VLI
> > Dec 12 00:24:15 santorini kernel: EFLAGS: 00010246   (2.6.9-55.0.9.ELsmp)

----------------------------------------------------------^^^^^^^^^^^^^^^^^^

<snip>


> Please tell the kernel version before post.

It's really really old :)

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
