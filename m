Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYKTG2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYKTG2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYKTG2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:28:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:48550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbYKTG2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:28:41 -0500
Message-ID: <4925039E.8020907@kernel.org>
Date: Thu, 20 Nov 2008 15:28:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org> <20080828181720.GB23898@kroah.com> <491BEC4E.9030505@kernel.org> <492136F5.8010903@kernel.org> <20081117171717.GB31306@kroah.com> <49221CE8.1050402@kernel.org> <49221D23.8040904@kernel.org> <4922C6BB.5020203@panasas.com> <4922E622.50401@kernel.org> <20081120055450.GA10821@kroah.com>
In-Reply-To: <20081120055450.GA10821@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 06:28:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> Hmmm... if you can use this change, I think you can push it through
>> whatever tree you push patches through, things can be taken care of when
>> merging or we can put it in Greg's tree and ask Miklos to pull from the
>> tree first but Greg doesn't keep a stable tree.
> 
> I don't keep a stable tree?  What do you mean?  It's a quilt tree, and
> it does get included in -next, so I think it does work :)

Heh... I meant stable (in the sense that it doesn't get rebased) git
tree which Miklos can pull from.

> Send it to me again and I'll push it through my tree if no one else
> objects.

Yeap, will resend it and let you and Miklos sort it out.

Thanks.

-- 
tejun
