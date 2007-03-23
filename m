Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXCWTIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXCWTIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXCWTIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:08:18 -0400
Received: from www.osadl.org ([213.239.205.134]:47441 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753406AbXCWTIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:08:16 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David L <idht4n@hotmail.com>
In-Reply-To: <20070323185028.GR752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 20:15:38 +0100
Message-Id: <1174677338.10840.321.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> Subject    : gettimeofday increments too slowly
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8027
> Submitter  : David L <idht4n@hotmail.com>
> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>              commit 92c7e00254b2d0efc1e36ac3e45474ce1871b6b2
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged

Patch available: http://lkml.org/lkml/2007/3/22/301

commit 6b3964cde70cfe6db79d35b42137431ef7d2f7e4

	tglx


