Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYBEPtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYBEPtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYBEPtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:49:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:40058 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755862AbYBEPtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:49:08 -0500
Date: Tue, 5 Feb 2008 16:49:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
In-Reply-To: <20080205154648.GA24331@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0802051648400.30955@jikos.suse.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
 <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org>
 <20080205154648.GA24331@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Pavel Machek wrote:

> uemacs ... broken with randomization
> colums, sss ... local programs, broken with randomization
> procinfo ... broken, randomization makes it die sooner.
> mikmod ... broken with randomization
> bsdsed ... broken with randomization
> ...
> Should I test few more?

Just to make things clear -- are all of these linked against the 1996 
version of libc.so.5?

Thanks,

-- 
Jiri Kosina
SUSE Labs
