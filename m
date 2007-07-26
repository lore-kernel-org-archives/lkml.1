Return-Path: <linux-kernel-owner+w=401wt.eu-S965024AbXGZVFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbXGZVFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934469AbXGZVFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:05:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934284AbXGZVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:05:09 -0400
Date: Thu, 26 Jul 2007 14:04:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bryan Wu <bryan.wu@analog.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Subject: Re: [GIT PULL try#3] Blackfin update
In-Reply-To: <1185437376.23987.34.camel@roc-desktop>
Message-ID: <alpine.LFD.0.999.0707261402180.3442@woody.linux-foundation.org>
References: <1185437376.23987.34.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Bryan Wu wrote:
> 
> Please pull from 'from-svn' branch of
> 
> master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git from-svn

I just get 

	error: no such remote ref refs/heads/from-svn
	fatal: Fetch failure: master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git

Hmm?

		Linus

(And why would anybody be as crazy as maintaining kernel patches in svn?)
