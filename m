Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYJBXN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYJBXN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYJBXNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:13:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbYJBXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:13:51 -0400
Date: Thu, 2 Oct 2008 16:13:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-10-02-14-45 uploaded
Message-Id: <20081002161348.d9845f97.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0810021600230.26309@shark.he.net>
References: <200810022145.m92LjihZ028042@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810021600230.26309@shark.he.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 16:02:41 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Thu, 2 Oct 2008, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-10-02-14-45 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27-rc8:
> 
> I wonder why I have patch FAILs & rejects:

welcome to my life.

> mmotm-2008-1002-1445> grep -C 3 FAIL pushall.txt 
> 
> Applying patch sky2-fix-recent-wol-regression.patch
> patching file drivers/net/sky2.c
> Hunk #1 FAILED at 3034.
> Hunk #2 succeeded at 3049 with fuzz 2 (offset 3 lines).
> Hunk #3 FAILED at 4172.
> Hunk #4 FAILED at 4232.
> 3 out of 4 hunks FAILED -- rejects in file drivers/net/sky2.c
> Patch sky2-fix-recent-wol-regression.patch can be reverse-applied

Yeah, that was a quick push so I could wave some patches under the
noses of various maintainers who have been cheerily ignoring the
needed-in-2.6.27 patches which I keep on sending them.

