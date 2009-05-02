Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZEBXe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZEBXe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 19:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZEBXeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 19:34:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbZEBXet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 19:34:49 -0400
Date: Sat, 2 May 2009 16:32:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joel Becker <Joel.Becker@oracle.com>
cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] ocfs2 fixes
In-Reply-To: <20090501230548.GD29617@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0905021632080.4983@localhost.localdomain>
References: <20090501230548.GD29617@mail.oracle.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Joel Becker wrote:
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/jlbec/ocfs2.git upstream-linus

No they're not.

Theres' a missing directory component there. Please fix your scripts.

I pulled, but I hate having to figure out where I should pull from,

		Linus
