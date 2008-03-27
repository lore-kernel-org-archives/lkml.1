Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYC0PQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYC0PQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 11:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYC0PQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 11:16:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbYC0PQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 11:16:27 -0400
Date: Thu, 27 Mar 2008 08:15:28 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <axboe@kernel.dk>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Message-ID: <20080327151528.GB13661@suse.de>
References: <abna7-7jK-3@gated-at.bofh.it> <abo6b-11J-9@gated-at.bofh.it> <aboSP-2Wf-29@gated-at.bofh.it> <aboSP-2Wf-27@gated-at.bofh.it> <abqrq-6eX-29@gated-at.bofh.it> <abqrq-6eX-27@gated-at.bofh.it> <abqKM-6Ka-13@gated-at.bofh.it> <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org> <20080327035257.GB9566@suse.de> <47EBB322.6000402@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EBB322.6000402@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:45:54AM -0400, Mark Lord wrote:
> Greg KH wrote:
>>
>> If sysfs is stupid, then use an ioctl, have I objected to that?
> ..
>
> Well, at this point it certainly seems a lot simpler
> than trying to get the sysfs "maintainers" to improve it.

I'm sorry, have I missed a patch that was submitted that adds this new
functionality?
