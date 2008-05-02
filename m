Return-Path: <linux-kernel-owner+w=401wt.eu-S937354AbYEBXPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937354AbYEBXPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbYEBXOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:14:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932513AbYEBXOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:14:52 -0400
Date: Fri, 2 May 2008 16:14:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Extend list debugging to cover hlists
Message-Id: <20080502161403.fe596cca.akpm@linux-foundation.org>
In-Reply-To: <20080502182745.GL14976@parisc-linux.org>
References: <20080502182745.GL14976@parisc-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 12:27:46 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> 
> We've seen a couple of recent reports which point to corrupt hlists.
> The DEBUG_LIST config option only checks regular lists, but it's not hard
> to cover hlists too.
>

patching file include/linux/list.h
Hunk #1 succeeded at 499 (offset -215 lines).
Hunk #2 FAILED at 567.
Hunk #3 succeeded at 545 (offset -293 lines).
Hunk #4 succeeded at 555 (offset -293 lines).
Hunk #5 FAILED at 585.
Hunk #6 FAILED at 614.
3 out of 6 hunks FAILED -- saving rejects to file include/linux/list.h.rej
patching file lib/list_debug.c
Failed to apply extend-list-debugging-to-cover-hlists

linux-next is a better tree against which to prepare 2.6.x+1 patches.
