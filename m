Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbYDSDMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbYDSDMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYDSDMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:12:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYDSDMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:12:44 -0400
Date: Fri, 18 Apr 2008 23:12:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       sandmann@redhat.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 4/5] ftrace: limit trace entries
In-Reply-To: <20080418131935.67daf8f0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804182311480.19025@gandalf.stny.rr.com>
References: <20080418200538.788522018@goodmis.org> <20080418200850.443055618@goodmis.org>
 <20080418131935.67daf8f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Apr 2008, Andrew Morton wrote:

> On Fri, 18 Apr 2008 16:05:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > +/**
> > + * detremine_dirtyable_memory - amount of memory that may be used
>
> tpyo
>

Damn! You don't miss a thing. Are you sure your name isn't Monk?

New patch coming.

Thanks,

-- Steve

