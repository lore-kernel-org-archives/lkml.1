Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbYHEIDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbYHEIDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYHEICl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:02:41 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:6945 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYHEICj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:02:39 -0400
Message-ID: <489808E0.6000208@fr.ibm.com>
Date: Tue, 05 Aug 2008 10:01:36 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andreas B Aaen <andreas.aaen@tietoenator.com>
CC: containers@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: SYSFS support together with NET_NS status?
References: <200808050940.59691.andreas.aaen@tietoenator.com>
In-Reply-To: <200808050940.59691.andreas.aaen@tietoenator.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas B Aaen wrote:
> Whats the status of the sysfs support for namespaces? Any idea when this will 
> go upstream - and through which git tree?
> 
> The patches from Eric W. Biederman isn't in the tree
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
> which I have been following.
> 
> Upstream support for sysfs together with namespaces will definately help with 
> more widespread usage of namespaces.

Definitely agree :)

I think the patches should be first in the Greg-KH tree.

Eric asked Greg-KH about this patchset 2 days ago, perhaps I missed it 
but I didn't see any answer yet.

   -- Daniel
