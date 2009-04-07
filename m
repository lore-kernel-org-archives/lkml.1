Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZDGR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZDGR3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZDGR3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:29:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbZDGR3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:29:07 -0400
Date: Tue, 7 Apr 2009 18:28:53 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, neilb@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dm: move bio_list fns to bio.h (was [PATCH])
Message-ID: <20090407172853.GL5688@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, neilb@suse.de,
	linux-kernel@vger.kernel.org
References: <20090407162014.GA11899@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407162014.GA11899@lst.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 06:20:14PM +0200, Christoph Hellwig wrote:
> It's used by DM and MD and generally useful, so move the bio list
> helpers into bio.h.
 
A good idea.

Jens - do you want to pick that up or shall I include it with the next little
batch (dm barrier support!) I'm preparing?

Alasdair
-- 
agk@redhat.com
