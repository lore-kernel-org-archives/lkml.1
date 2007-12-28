Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbXL1Hgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbXL1Hgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXL1Hgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:36:46 -0500
Received: from pils.linux-kernel.at ([213.129.242.82]:8480 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbXL1Hgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:36:45 -0500
Message-ID: <4774A774.8020404@linux-kernel.at>
Date: Fri, 28 Dec 2007 08:36:20 +0100
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Justin Banks <justinb@bakbone.com>
CC: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic - help!?
References: <475FA716.2000105@linux-kernel.at> <a8e1da0712120156v2b855f64jf40f9971ebf9b689@mail.gmail.com> <20071212142436.GB16664@bleen.domain.actdsltmp>
In-Reply-To: <20071212142436.GB16664@bleen.domain.actdsltmp>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: lBS7aKvT017572
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.009, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	PLING_QUERY 1.39)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2007 03:24 PM, Justin Banks wrote:
> Dave Young wrote
>> On Dec 12, 2007 5:17 PM, Oliver Falk <oliver@linux-kernel.at> wrote:
>>> Can someone explain me that?
>>>
>>> Dec 12 00:24:15 santorini kernel: Unable to handle kernel NULL pointer
>>> dereference at virtual address 00000000
>>> Dec 12 00:24:15 santorini kernel:  printing eip:
>>> Dec 12 00:24:15 santorini kernel: c0190182
>>> Dec 12 00:24:15 santorini kernel: *pde = 1b62b001
>>> Dec 12 00:24:15 santorini kernel: Oops: 0000 [#1]
>>> Dec 12 00:24:15 santorini kernel: SMP
>>> Dec 12 00:24:15 santorini kernel: Modules linked in: mptctl mptbase sg
>>> md5 ipv6 i2c_dev i2c_core button battery ac uhci_hcd ehci_hcd hw_rand
>>> om tg3 bonding(U) floppy ata_piix libata dm_snapshot dm_zero dm_mirror
>>> ext3 jbd dm_mod cciss sd_mod scsi_mod
>>> Dec 12 00:24:15 santorini kernel: CPU:    2
>>> Dec 12 00:24:15 santorini kernel: EIP:    0060:[<c0190182>]    Not
>>> tainted VLI
>>> Dec 12 00:24:15 santorini kernel: EFLAGS: 00010246   (2.6.9-55.0.9.ELsmp)
> 
> ----------------------------------------------------------^^^^^^^^^^^^^^^^^^
> 
> <snip>
> 
> 
>> Please tell the kernel version before post.
> 
> It's really really old :)

of@santorini:~$ uname -r
2.6.9-55.0.9.ELsmp

Some RHEL system....

-of
