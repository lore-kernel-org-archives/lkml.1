Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZCPKOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZCPKOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbZCPKO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:14:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097AbZCPKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:14:27 -0400
Date: Mon, 16 Mar 2009 06:14:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: Re: [PATCH 4/7] writeback: get rid of task/current_is_pdflush()
Message-ID: <20090316101425.GB21118@infradead.org>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-5-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236868428-20408-5-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:33:45PM +0100, Jens Axboe wrote:
> There's just a single user in the kernel and Chris says it's safe to kill.

I'll defer about the use to Chris, but if this can go it should now,
not deep inside the series.

