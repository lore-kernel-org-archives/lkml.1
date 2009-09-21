Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZIUTpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZIUTpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZIUTpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:45:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44247 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZIUTpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:45:15 -0400
Date: Mon, 21 Sep 2009 21:45:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/3] block: Add blk_queue_copy_limits()
Message-ID: <20090921194518.GJ23126@kernel.dk>
References: <4AB3B43D.9000802@ce.jp.nec.com> <yq1eiq46ohz.fsf@sermon.lab.mkp.net> <4AB4F74E.7000908@ce.jp.nec.com> <yq1k4zt5o2f.fsf@sermon.lab.mkp.net> <4AB7AAE2.8000404@ce.jp.nec.com> <yq1iqfc3wyw.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1iqfc3wyw.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21 2009, Martin K. Petersen wrote:
> >>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> Jun'ichi> If we aren't sure, shouldn't we set its default to -1 or
> Jun'ichi> putting comments in blk_set_default_limits() at least to avoid
> Jun'ichi> possible confusion in future?
> 
> Jens, what do you think about this?  Goes on top of what you have
> queued...

Look sane, applied.

-- 
Jens Axboe

