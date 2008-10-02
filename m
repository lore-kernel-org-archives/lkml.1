Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYJBXCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYJBXCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYJBXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:02:44 -0400
Received: from xenotime.net ([66.160.160.81]:53200 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752722AbYJBXCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:02:44 -0400
Date: Thu, 2 Oct 2008 16:02:41 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-10-02-14-45 uploaded
In-Reply-To: <200810022145.m92LjihZ028042@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810021600230.26309@shark.he.net>
References: <200810022145.m92LjihZ028042@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-10-02-14-45 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27-rc8:

I wonder why I have patch FAILs & rejects:

mmotm-2008-1002-1445> grep -C 3 FAIL pushall.txt 

Applying patch sky2-fix-recent-wol-regression.patch
patching file drivers/net/sky2.c
Hunk #1 FAILED at 3034.
Hunk #2 succeeded at 3049 with fuzz 2 (offset 3 lines).
Hunk #3 FAILED at 4172.
Hunk #4 FAILED at 4232.
3 out of 4 hunks FAILED -- rejects in file drivers/net/sky2.c
Patch sky2-fix-recent-wol-regression.patch can be reverse-applied


-- 
~Randy
