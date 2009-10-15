Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbZJOAYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbZJOAYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbZJOAYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbZJOAYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:24:36 -0400
Date: Thu, 15 Oct 2009 01:23:50 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark McLoughlin <markmc@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH resend] block: silently error unsupported
	empty barriers too
Message-ID: <20091015002350.GV16950@agk-dp.fab.redhat.com>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Mark McLoughlin <markmc@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	device-mapper development <dm-devel@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <1251992870.3084.125.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251992870.3084.125.camel@blaa>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 04:47:50PM +0100, Mark McLoughlin wrote:
> We should error all barriers, even empty barriers, on devices like
> virtio_blk which don't support them.

Acked-by: Alasdair G Kergon <agk@redhat.com>

