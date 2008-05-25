Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbYEYTaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbYEYTaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbYEYTa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:30:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353AbYEYTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:30:27 -0400
Date: Sun, 25 May 2008 15:30:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Marin Mitov <mitov@issp.bas.bg>
cc: linux-kernel@vger.kernel.org
Subject: Re:[PATCH -v4] x86: enable preemption in delay
In-Reply-To: <200805252108.25011.mitov@issp.bas.bg>
Message-ID: <Pine.LNX.4.58.0805251528560.25580@gandalf.stny.rr.com>
References: <200805252108.25011.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 May 2008, Marin Mitov wrote:

> Hi Steven,
>
> look at this patch, proposed by me and Ingo few month ago.
> I think it solves the problem you had fond, but unfortunately
> it had been lost (not included in the mainline).
>
> http://lkml.org/lkml/2007/11/20/343
>
> It is against the kernel at the moment the message was sent.
> I think it could be applied to the current kernel too.
>

Hi Marin,

That patch looks basically like what I did. But mine has less code and is
a bit simpler ;-)

Thanks,

-- Steve

