Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbZLQJpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbZLQJpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761294AbZLQJpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:45:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53201 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZLQJpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:45:14 -0500
Date: Thu, 17 Dec 2009 10:44:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Alex Elder <aelder@sgi.com>,
       Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091217094437.GA12228@elte.hu>
References: <20091217090250.GA4844@elte.hu>
 <20091217092719.GA13397@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217092719.GA13397@lst.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> What filesystems are you using, especially for the root filesystem or
> anything used during boot?

ext3, Fedora. Regular distro stuff, nothing fancy.

	Ingo
