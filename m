Return-Path: <linux-kernel-owner+w=401wt.eu-S1765413AbYBMBVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765413AbYBMBVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764933AbYBMBVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:21:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:14836 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYBMBV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:21:27 -0500
Date: Tue, 12 Feb 2008 17:20:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080212172008.d365b839.randy.dunlap@oracle.com>
In-Reply-To: <20080212120208.f7168a91.sfr@canb.auug.org.au>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 12:02:08 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Andrew was looking for someone to run a linux-next tree that just
> contained the subsystem git and quilt trees for 2.6.x+1 and I (in a
> moment of madness) volunteered.  So, this is to announce the creating of
> such a tree (it doesn't exist yet) which will require some (hopefully)
> small amount of work on the part of subsystem maintainers.
> 
> Those interested in discussion about this are encouraged to join the
> linux-next@vger.kernel.org mailing list.
> 
> The first things I need from the subsystem maintainers (you know who you
> are) are a contact address (a list address is fine) and at least one git
> branch or quilt series that contains all the things you want to see go
> into 2.6.26.  I am happy for there to be multiple branches/series (in
> fact there probably will need to be in some cases where there are
> dependencies on others work).

Hi Stephen,

Please merge the quilt series/patchset from
  http://oss.oracle.com/~rdunlap/kernel-doc-patches/current/

I expect this to be fairly small and localized (very few conflicts).

Thanks,
---
~Randy
