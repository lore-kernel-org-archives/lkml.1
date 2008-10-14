Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYJNIYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYJNIYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYJNIYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:24:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYJNIYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:24:37 -0400
Message-ID: <48F4568B.7000609@kernel.org>
Date: Tue, 14 Oct 2008 17:21:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
In-Reply-To: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Oct 2008 08:23:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

I'm about ready to send the next round of this patchset w/ mmap support,
which I'm sure gonna stir up some discussion. :-) Several things I wanna
hear your comments about.

1. I'll try to incorporate all other comments here but regarding ioctl I
don't think we've reached any better solution, so I'm sticking with the
original one.

2. You told me that the version branching in the userland library wasn't
necessary.  Can you explain to me when FUSE version bumping is necessary?

3. Any other things on you mind?

Thanks.

-- 
tejun
