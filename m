Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbXCTLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbXCTLSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXCTLSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:18:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60991 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753576AbXCTLSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:18:16 -0400
Date: Tue, 20 Mar 2007 12:18:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ptrace needs PROC_FS
Message-ID: <20070320111808.GA27036@elf.ucw.cz>
References: <20070319152616.d0857587.randy.dunlap@oracle.com> <20070319224847.6FAB71801C5@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319224847.6FAB71801C5@magilla.sf.frob.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Thanks, that Kconfig change seems like the simplest solution for this.

Simplest, maybe, but is it right? Ptrace should work without /proc, no?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
