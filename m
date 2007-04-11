Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXDKHBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXDKHBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXDKHBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:01:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38668 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXDKHBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:01:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: [patch] uninline remove/add_parent() APIs
References: <20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu>
	<m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
	<20070410150650.GA9946@elte.hu>
	<m1tzvoxniv.fsf@ebiederm.dsl.xmission.com>
	<20070410155314.GA16267@elte.hu> <20070411062041.GA8017@elte.hu>
Date: Wed, 11 Apr 2007 01:00:17 -0600
In-Reply-To: <20070411062041.GA8017@elte.hu> (Ingo Molnar's message of "Wed,
	11 Apr 2007 08:20:41 +0200")
Message-ID: <m1ps6btmym.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> here's a (tested) patch i did that should simplify changes done to 
> p->children and p->sibling handling.

Looks reasonable.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Should we copy Andrew or is someone else going to collect up all of these patches?

Eric
