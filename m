Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZDOVJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZDOVJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZDOVIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:08:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754253AbZDOVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:08:54 -0400
Date: Wed, 15 Apr 2009 14:05:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Takashi Iwai <tiwai@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but
 annoying) audio problem
In-Reply-To: <200904152259.10473.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0904151402460.4042@localhost.localdomain>
References: <200904100057.43827.rjw@sisk.pl> <200904142312.33833.rjw@sisk.pl> <s5hbpqy12mh.wl%tiwai@suse.de> <200904152259.10473.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Rafael J. Wysocki wrote:
> 
> I'm going to try 2.6.30-rc2-git in a while.  If I have the time, I'll also test
> the sound git tree.

There's a sound merge today (ie post-rc2) which hopefully contains the 
relevant fixes. 

			Linus
