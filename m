Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYIZJju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYIZJju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYIZJjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:39:40 -0400
Received: from fogou.chygwyn.com ([195.171.2.24]:58690 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYIZJjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:39:39 -0400
Date: Fri, 26 Sep 2008 10:37:30 +0100
From: steve@chygwyn.com
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/10] gfs2: Fix error handling in
	write_super_lockfs/unlockfs
Message-ID: <20080926093730.GA5346@fogou.chygwyn.com>
References: <20080926175821t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926175821t-sato@mail.jp.nec.com>
Organization: ChyGwyn Limited
X-Registered-Office: Digital Technium, Singleton Park, Swansea. SA2 8PP
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 26, 2008 at 05:58:21PM +0900, Takashi Sato wrote:
> Changed write_super_lockfs so that it returns an error in case of an failure.
> unlockfs always returns 0.

Looks good now. Thanks,

Steve.
