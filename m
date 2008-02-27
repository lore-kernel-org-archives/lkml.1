Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYB0Uwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYB0Uwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYB0Uw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:52:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbYB0Uw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:52:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: Re: [PATCH] x86 vdso: fix build locale dependency
In-Reply-To: Ingo Molnar's message of  Wednesday, 27 February 2008 21:45:13 +0100 <20080227204513.GB1510@elte.hu>
References: <20080227194215.0B5A32700FD@magilla.localdomain>
	<20080227204321.GA13309@uranus.ravnborg.org>
	<20080227204513.GB1510@elte.hu>
Emacs: no job too big... no job.
Message-Id: <20080227205220.2A88F2700FD@magilla.localdomain>
Date: Wed, 27 Feb 2008 12:52:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok. I've queued up Roland's re-fix. We'll eventually converge to 
> something everyone is happy with ;-)

Hey, I'm happy with living in the C locale.  It's catering to you
troublesome people covering the vast majority of the planet that has
me worrying about pedantic correctness for whatever the least-similar
LC_CTYPE anyone uses might entail.  :-)


Thanks,
Roland
