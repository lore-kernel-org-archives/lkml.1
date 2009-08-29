Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbZH2FsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbZH2FsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 01:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZH2FsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 01:48:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbZH2FsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 01:48:23 -0400
Date: Fri, 28 Aug 2009 19:48:07 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.31-rc8 inotify hangs samba clients
In-Reply-To: <b6a2187b0908280930s6366eda6pe1d5024b4ef890dd@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0908281945590.10281@eeepc.linux-foundation.org>
References: <Pine.LNX.4.64.0908282358560.19623@boston.corp.fedex.com>  <1251476422.28787.1.camel@dhcp231-106.rdu.redhat.com> <b6a2187b0908280930s6366eda6pe1d5024b4ef890dd@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Aug 2009, Jeff Chua wrote:
> 
> Thanks again for the pointer and fixes. Will wait to pull from Linus's 
> git.

Ok, I've merged the inotify things (along with a few others changes). 
Please do give it a good test. I'm going to be online only to a _very_ 
limited degree (four-tank dive day tomorrow! Yeehaa), so I really hope 
that this solves it all.

			Linus
