Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbZLSLBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbZLSLBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 06:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZLSLBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 06:01:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37618 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZLSLBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 06:01:36 -0500
To: Jim Garlick <garlick@llnl.gov>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sage Weil <sage@newdream.net>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, greg@kroah.com
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net>
	<Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net>
	<alpine.LFD.2.00.0912181327200.3712@localhost.localdomain>
	<20091218231505.GA21371@llnl.gov>
Date: Sat, 19 Dec 2009 12:01:33 +0100
In-Reply-To: <20091218231505.GA21371@llnl.gov> (Jim Garlick's message of "Fri, 18 Dec 2009 15:15:05 -0800")
Message-ID: <87ws0jtegi.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Garlick <garlick@llnl.gov> writes:
>
> Ceph is new and experimental so you're not going to see production shops

One issue with ceph is that I'm not sure it has any users at all.
The mailing list seems to be pretty much dead?
On a philosophical area I agree that network file systems are
definitely an area that could need some more improvements.

> like ours jumping up and down saying we use it and are tired of merging it,
> like we would say if if Lustre were (again) on the table.

OT, but I took a look at some Lustre srpm a few months ago and it
didn't seem to still require all the horrible VFS patches that the
older versions were plagued with (or perhaps I missed them). Because
it definitely seems to have a large real world user base perhaps it
would be something for staging at least these days?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
