Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZHRGCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZHRGCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZHRGCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:02:14 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:56071 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZHRGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:02:13 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: drbd tree build failure
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090729152938.791a81c3.sfr@canb.auug.org.au>
	<yq1prbk59bv.fsf@sermon.lab.mkp.net>
	<20090818153250.5ce293b5.sfr@canb.auug.org.au>
Date: Tue, 18 Aug 2009 02:01:58 -0400
In-Reply-To: <20090818153250.5ce293b5.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Tue, 18 Aug 2009 15:32:50 +1000")
Message-ID: <yq1hbw5hd7t.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A8A43D9.0138:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stephen" == Stephen Rothwell <sfr@canb.auug.org.au> writes:

>> We've decided to keep blk_queue_stack_limits as a wrapper to ease the
>> transition.  I sent Jens a patch earlier today that does this.

Stephen> I am still getting this error (3 weeks later) ...  :-(

Jens applied it to for-linus and it's been upstream for a while.  But it
looks like the block for-next tree has stale bits...

Jens?

-- 
Martin K. Petersen	Oracle Linux Engineering
