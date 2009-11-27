Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZK0DAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZK0DAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 22:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZK0DAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 22:00:47 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:26635 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbZK0DAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 22:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DSBEVkSKYD9qlIj8iFgJTDnplUetmRWyiHWKlQa7VB/BOwWUK4FuDGyNgZ8lC071DX
         iEUp4+zBZqsC/IAKlhU9eAIX3ljwVIKzs8uTHiH4Jxkor2rlgRAOLRSowHTTpgFObZ+8
         2Fag1ycaJbajBpw5MvBcpuNQWcP9T7HkUgCpE=
Date: Fri, 27 Nov 2009 04:00:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Buchner <buchner.johannes@gmx.at>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: Fw: reiser4 git repo
Message-ID: <20091127030050.GC5406@nowhere>
References: <20091127155148.dcc5cdee.buchner.johannes@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127155148.dcc5cdee.buchner.johannes@gmx.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 03:51:48PM +1300, Johannes Buchner wrote:
> [ I sent this 2 days ago to linux-fsdevel@vger.kernel.org, maybe I'll
> get more responses in here. ]
> 
> Hi!
> 
> I would like to keep a git repo up to date with current kernel
> development, with reiser4 patched in. I am having trouble finding a
> repo that provides reiser4. Is there one?
> 
> Some people may have noticed the last patch doesn't apply cleanly
> anymore. I made a few lines of modifications in my local repo. Maybe
> that repo would be interesting for others too*.
> 
> I plan to catch up with changes from kernel development on a
> daily/weekly basis; my /home partition is reiser4, so I am fairly
> serious about it.
> 
> At the moment, I fetch from torvalds/linux-2.6.git and 
> stable/linux-2.6.31.y.git. Am I missing any other repositories that I
> should try to keep up with? (A fs subsystem maintainer repo?)
> next/linux-next.git is probably moving too fast for me.


You can try the -mm tree, the reiser 4 patches can be found inside:

http://userweb.kernel.org/~akpm/mmotm/

