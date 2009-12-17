Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbZLQJyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbZLQJyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764247AbZLQJye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:54:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45664 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763269AbZLQJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:54:33 -0500
Date: Thu, 17 Dec 2009 09:54:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Alex Elder <aelder@sgi.com>, Mark Fasheh <mfasheh@suse.com>,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091217095431.GA14381@ZenIV.linux.org.uk>
References: <20091217090250.GA4844@elte.hu> <20091217093216.GZ14381@ZenIV.linux.org.uk> <20091217094448.GB12228@elte.hu> <20091217095214.GA16810@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217095214.GA16810@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:52:14AM +0100, Ingo Molnar wrote:

> Fixes the crash, thanks Al!
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Already in vfs-2.6.git on hera; should propagate in a few.
I'm going to grab a couple of hours of sleep, then push the
second pile in there and post a pull request.
