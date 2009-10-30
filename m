Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZJ3Tsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZJ3Tsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZJ3Tsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:48:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913AbZJ3Tsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:48:39 -0400
Date: Fri, 30 Oct 2009 12:48:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alex Elder <aelder@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [GIT PULL] XFS (2 regression fixes)
In-Reply-To: <200910301857.n9UIvZ6w009983@stout.americas.sgi.com>
Message-ID: <alpine.LFD.2.01.0910301247480.31845@localhost.localdomain>
References: <200910301857.n9UIvZ6w009983@stout.americas.sgi.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Oct 2009, Alex Elder wrote:
>
> Linus, Christoph Hellwig sent a pull request for these patches from
> the xfs-dev tree on kernel.org earlier today.  (Pointing this out to
> hopefully avoid confusion.)

I'll pull from Christophs tree directly - I refuse to pull from trees that 
have more merge commits than actual real commits.

		Linus
> Alex Elder (2):
>       Merge branch 'master' of ssh://oss.sgi.com/oss/git/xfs/xfs into for-linus
>       Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into for-linus

Both of these seem pointless, and a sign of something wrong.

		Linus
