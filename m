Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbXB1MD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbXB1MD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbXB1MD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:03:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36296 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932127AbXB1MD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:03:57 -0500
Date: Wed, 28 Feb 2007 13:02:47 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Patrick Ale <patrick.ale@gmail.com>,
       Michael-Luke Jones <jonesml@fastmail.to>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] Sata RAID
Message-ID: <20070228130247.080d19f3@lxorguk.ukuu.org.uk>
In-Reply-To: <45E4E036.20507@tmr.com>
References: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>
	<200702241624.17024.bzolnier@gmail.com>
	<6C96CE3D-85F5-479D-BD44-F5DA0AE744FF@fastmail.to>
	<8d158e1f0702240919v33182ca2qc0a15fdd27a3f96a@mail.gmail.com>
	<8d158e1f0702260030l2f3d9f2ar5c662c807f64f7f7@mail.gmail.com>
	<45E4E036.20507@tmr.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Would you use MD at all, taking in account the disks come from the
> > same batch and all? I hear these things about MD/RAID being pointless
> > when you use disks from the same brand/type/batch since they most
> > likely will break shortly after each other.
> 
> Well, for values of "shortly" in months in most cases. These are 
> consumer goods, I would not expect units with consecutive serial numbers 
> to fail separated by such a short time that you can't do a backup and/or 

I've had them fail within days when using almost identical serial
numbers. Nowdays I just mix disk vendors on each array. End of problem.
