Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYDQIcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYDQIcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYDQIcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:32:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49053 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbYDQIcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:32:12 -0400
Date: Thu, 17 Apr 2008 11:32:09 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
In-Reply-To: <20080417012051.ed56f4ab.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org>
 <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
 <20080417012051.ed56f4ab.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Andrew Morton wrote:
> > No, I fixed some of those and I think Ingo/Soren did the rest. But it
> > needs another round of review on LKML for sure.
> 
> afaict none of my review comments have been addressed in the sysprof.c which
> is in -mm.  It has the following commits:
> 
>     x86, sysprof: merge header to compilation unit
>     x86, sysprof: clean up stack frame copying
>     x86, sysprof: remove dead code
>     sysprof: user pointer verification
>     sysprof: minor cleanups
>     x86: add the debugfs interface for the sysprof tool
> 
> I received no email even acknowledging the review comments.

Oh sorry, I guess I fixed up problems I spot myself. There indeed seem to 
be some comments by Andrew that have not been addressed:

  http://lkml.org/lkml/2008/2/23/68

			Pekka
