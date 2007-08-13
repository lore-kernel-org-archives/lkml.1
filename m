Return-Path: <linux-kernel-owner+w=401wt.eu-S942864AbXHMRF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942864AbXHMRF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942134AbXHMQmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:42:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S943064AbXHMQmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:42:17 -0400
Message-ID: <46C08941.20609@redhat.com>
Date: Mon, 13 Aug 2007 11:39:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Theodore Tso <tytso@mit.edu>, torvalds@linux-foundation.org,
       sct@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
       Eric Sandeen <esandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
References: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com>	 <20070813090128.GJ6689@schatzie.adilger.int>	 <20070813151917.GA28130@thunk.org> <1187021641.10249.90.camel@localhost>
In-Reply-To: <1187021641.10249.90.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2007-08-13 at 11:19 -0400, Theodore Tso wrote:
>> Yep, agreed.
> 
> OK. saved in my tree as
> 
> EXT4 FILE SYSTEM
> P:      Ted Ts'o
> M:	tytso@mit.edu
> P:	Eric Sandeen
> M:	sandeen@sgi.com

Close... try sandeen@redhat.com, now :)

Andreas should still be in there I think (his prior message suggested
replacing Stephen & Andrew with Ted, Mingmimg and me, I think - but not
to replace Andreas - Andreas, correct me if I'm wrong...)

(And to be fair about it in terms of actual work done so far, please put
the other names ahead of mine!)  :)

Thanks,

-Eric

> P:	Mingming Cao
> M:	cmm@us.ibm.com
> L:	linux-ext4@vger.kernel.org
> S:	Maintained
> F:	fs/ext4/
> F:	include/linux/ext4*
> 
> Separate question.  Is it right that the L: entries
> for ext2/3/4 are all linux-ext4@vger.kernel.org?
> 

