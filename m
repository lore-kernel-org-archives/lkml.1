Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZC3Tk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZC3Tk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbZC3TkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:40:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759119AbZC3TkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:40:05 -0400
Date: Mon, 30 Mar 2009 12:38:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Mahoney <jeffm@suse.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 00/35] Jeff's ReiserFS Patch Queue
In-Reply-To: <20090330180215.951354436@suse.com>
Message-ID: <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain>
References: <20090330180215.951354436@suse.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Jeff Mahoney wrote:
> 
> I'd like to submit my reiserfs patch queue for inclusion into 2.6.30.

Hmm. Looks fine, and I merged it. I had a number of mostly trivial 
conflicts (most due to the quota name cleanup to lower-case, with some 
header file export cleanup conflicts added in), but they looked fairly 
straightforward and I compile-tested the end result.

I don't have any reiserfs filesystems left, though, so you should really 
double-check the end result.

> Once this is applied, I expect reiserfs to be in deep maintenance-only 
> mode.

Heh, I hadn't expected even this.

		Linus
