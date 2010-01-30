Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498Ab0A3T2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0A3T2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388Ab0A3T2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:28:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50629 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab0A3T2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:28:44 -0500
Date: Sat, 30 Jan 2010 20:28:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] block: fix bugs in bio-integrity mempool usage
Message-ID: <20100130192843.GX13771@kernel.dk>
References: <201001290102.o0T12nHu022353@int-mx05.intmail.prod.int.phx2.redhat.com> <yq1d40r5rzz.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1d40r5rzz.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30 2010, Martin K. Petersen wrote:
> 
> block: fix bugs in bio-integrity mempool usage
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks Chuck and Martin, applied to for-linus

-- 
Jens Axboe

