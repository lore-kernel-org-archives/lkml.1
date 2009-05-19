Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZESJRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZESJRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZESJRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:17:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35577 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZESJRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:17:23 -0400
Date: Tue, 19 May 2009 11:17:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH UPDATED2 block#for-2.6.31 2/3] block: set rq->resid_len
	to  blk_rq_bytes() on issue
Message-ID: <20090519091724.GT4140@kernel.dk>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FFD7E.8050607@gmail.com> <20090518124919.GK4140@kernel.dk> <4A127864.8090701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A127864.8090701@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19 2009, Tejun Heo wrote:
> Hello, Jens.
> 
> Jens Axboe wrote:
> > Tejun, you have to stop replying with updated patches in an existing
> > thread. It's virtually impossible to sort the resulting mess into
> > patches worth applying.
> 
> Heh.. yeah, I usually post minor updates as UPDATED patches for review
> then repost the whole series after accumulating some of them.  This
> patchset's size was on the borderline for proper patchset and I was
> feeling lazy.  Sorry about that.  Will repost.

Thanks, appreciated :-)

-- 
Jens Axboe

