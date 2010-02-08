Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0BHS1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:27:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab0BHS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:26:58 -0500
Date: Mon, 8 Feb 2010 10:26:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.2.33] Fix regressions on dvb demux
In-Reply-To: <4B703E1D.8090705@redhat.com>
Message-ID: <alpine.LFD.2.00.1002081011060.3829@localhost.localdomain>
References: <4B703E1D.8090705@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Feb 2010, Mauro Carvalho Chehab wrote:
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/fixes.git v4l_for_linus

I don't have ssh access to that thing, and git:// doesn't work.

You probably meant

	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6

but it's not pushed out to there yet.

		Linus
