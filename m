Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbYF0JAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbYF0JAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbYF0JAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:00:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714AbYF0JAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:00:39 -0400
Message-ID: <4864AC27.8040204@redhat.com>
Date: Fri, 27 Jun 2008 11:00:23 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
CC: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: What's in linux-2.6-block.git for 2.6.27
References: <20080626115404.GS20851@kernel.dk>
In-Reply-To: <20080626115404.GS20851@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> So this time it's a little beyond just block stuff, since the
> generic-ipi branch is included (in preparation for block parts actually
> using that code).

Hi,

please could you also add this patch?
http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-md-merge_bvec_fn-with-separate-bdev-and-sector.patch

(following device-mapper bvec merge function patches rely on it...)

Or is there some objections to not include it?

Thanks,
Milan
--
mbroz@tredhat.com
