Return-Path: <linux-kernel-owner+w=401wt.eu-S1764197AbZLQJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764197AbZLQJ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZLQJ2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:28:47 -0500
Received: from verein.lst.de ([213.95.11.210]:36171 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764153AbZLQJ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:28:44 -0500
Date: Thu, 17 Dec 2009 10:27:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Alex Elder <aelder@sgi.com>,
       Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091217092719.GA13397@lst.de>
References: <20091217090250.GA4844@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217090250.GA4844@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What filesystems are you using, especially for the root filesystem or
anything used during boot?
