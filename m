Return-Path: <linux-kernel-owner+w=401wt.eu-S933748AbXBZDzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbXBZDzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 22:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933750AbXBZDzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 22:55:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:48122 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933748AbXBZDzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 22:55:13 -0500
X-Provags-ID: V01U2FsdGVkX19fHwY9yqNfy1NJoOOGCkUwWbFq6OcPCP5dkq35hB
	JyjQ==
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive
	cannot be mounted without hanging up the whole system
From: Mike Galbraith <efault@gmx.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070225182939.154020@gmx.net>
References: <20070225182939.154020@gmx.net>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 04:55:06 +0100
Message-Id: <1172462106.6850.8.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 19:29 +0100, Uwe Bugla wrote:
> Hi everybody,
> "The bug was introduced somewhere at the transition of 2.6.20 towards 2.6.20-git14."
> I fortunately had some git9 patch at home and found out that it is sane.
> In so far the floppy mount bug was introduced somewhen between 2.6.20-git10 and 2.6.20-git14.
> "I'm afraid that the most proactical (it spells "practical", Mr. Morton) way of fixing this is to ask you to run a git-bisect to find the changeset which introduced the regression."
> Until you aren't even ready to explain me the exact technique of bisecting I won't do it and I can't do it.

Feeding google "how to git bisect" returns the below as it's first hit.
http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html

<psyco-blather deleted>

