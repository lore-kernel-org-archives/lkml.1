Return-Path: <linux-kernel-owner+w=401wt.eu-S1422777AbXBARlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422777AbXBARlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422763AbXBARlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:41:25 -0500
Received: from javad.com ([216.122.176.236]:2141 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760AbXBARlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:41:24 -0500
From: Sergei Organov <osv@javad.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: QUATECH driver (was Free Linux Driver Development!)
Date: Thu, 01 Feb 2007 20:41:06 +0300
Message-ID: <87hcu522tp.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan <alan@lxorguk.ukuu.org.uk> writes:
>> 3. Vendor driver is rather close to the generic one being in the kernel,
>>    so maybe it's better to improve generic one instead of adding yet
>>    another driver to the tree.
>
> Firstly can you post a patch which adds the relevant identifiers to the
> current pcmcia serial driver so that 115,200 works but nothing higher.

OK, I'll try to recover what I did (as I've dropped the change after I
saw it can't do 460,800), and submit the patch.

> After that I'd like to take a look at the needed changes for higher speed
> support using the 2.6.20-mm work which adds arbitary speed support.

I expect it'll be rather hard for me to test the changes then, as my IBM
ThinkPad T43 suffers from kernel IDE/SATA/PATA issues, and running every
new kernel was a big pain so far (it currently runs 2.6.16.8) :(

-- Sergei.
