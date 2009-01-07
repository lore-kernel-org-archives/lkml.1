Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZAGCwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZAGCwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZAGCwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:52:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZAGCwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:52:02 -0500
Date: Tue, 6 Jan 2009 21:52:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       roel.kluin@gmail.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 2/3] ring-buffer: rename debugfs file tracing_on to
 writing_enabled
In-Reply-To: <20090106144740.686c3f33.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901062145340.25237@gandalf.stny.rr.com>
References: <20090106223337.677427397@goodmis.org> <20090106223405.512131804@goodmis.org> <20090106144740.686c3f33.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 6 Jan 2009, Andrew Morton wrote:

> On Tue, 06 Jan 2009 17:33:39 -0500
> 
> There's no corresponding documentation update needed?

I've fallen a little behind in the documentation. I wanted to see what got 
pulled in before updating ftrace.txt. But you are correct, I probably 
should add the documentation updates along with the patches.

But unfortunately, I'm a bit lazy. I like to wait and see what makes it to 
mainline, and then write a patch to update ftrace.txt to reflect that. It 
lets me do it in one sitting, instead of doing it for each change.

Honestly, I think I document it better that way. If I document right after 
writing the code, I do it with too much knowledge of the code, and my 
writing is confusing for others. If I wait to document, I forget what I 
did, and have to relearn what I wrote, and then I have a better 
perspective of what others will want to know.

Thanks,

-- Steve

