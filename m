Return-Path: <linux-kernel-owner+w=401wt.eu-S1765211AbXJTCtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765211AbXJTCtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXJTCtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:49:10 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:38893 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXJTCtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:49:09 -0400
Message-ID: <47196C9B.7090909@tiscali.nl>
Date: Sat, 20 Oct 2007 04:48:59 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] RT: Only dirty a cacheline if the priority is actually
 changing
References: <20071017184745.11272.10024.stgit@novell1.haskins.net> <20071017185113.11272.50568.stgit@novell1.haskins.net>
In-Reply-To: <20071017185113.11272.50568.stgit@novell1.haskins.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> We can avoid dirtying a rq related cacheline with a simple check, so why not.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)

I think you wanted a patch here?
