Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbZJOTMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbZJOTMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762940AbZJOTMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:12:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762932AbZJOTMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:12:12 -0400
Date: Thu, 15 Oct 2009 15:11:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alasdair G Kergon <agk@redhat.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Mark McLoughlin <markmc@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH resend] block: silently error unsupported
 empty barriers too
In-Reply-To: <20091015002350.GV16950@agk-dp.fab.redhat.com>
Message-ID: <Pine.LNX.4.64.0910151510340.22075@hs20-bc2-1.build.redhat.com>
References: <1251992870.3084.125.camel@blaa> <20091015002350.GV16950@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, Alasdair G Kergon wrote:

> On Thu, Sep 03, 2009 at 04:47:50PM +0100, Mark McLoughlin wrote:
> > We should error all barriers, even empty barriers, on devices like
> > virtio_blk which don't support them.
> 
> Acked-by: Alasdair G Kergon <agk@redhat.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>
