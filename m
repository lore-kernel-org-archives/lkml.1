Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZESJNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZESJNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZESJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:12:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:54571 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZESJM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x26upb9m0AEttSyFDmhQbmxxi5OuSz2RpZ4D9tWlWeKpad+5A9fmX6D5n4p9Gsg51r
         ijxPg785j6+JDqB3fNGQlYhdpm1Lcu4Zk6f7HXk6VqL/jresZpjS224KdtpFEVNWkBBI
         uxgqP2ZHEVdKRCz/mvqjWkMAxHul5ASYwF0vw=
Message-ID: <4A127864.8090701@gmail.com>
Date: Tue, 19 May 2009 18:14:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
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
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FFD7E.8050607@gmail.com> <20090518124919.GK4140@kernel.dk>
In-Reply-To: <20090518124919.GK4140@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> Tejun, you have to stop replying with updated patches in an existing
> thread. It's virtually impossible to sort the resulting mess into
> patches worth applying.

Heh.. yeah, I usually post minor updates as UPDATED patches for review
then repost the whole series after accumulating some of them.  This
patchset's size was on the borderline for proper patchset and I was
feeling lazy.  Sorry about that.  Will repost.

Thanks.

-- 
tejun
