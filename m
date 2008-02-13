Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbYBMH22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbYBMH22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbYBMH2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:28:12 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:39828 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbYBMH2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:28:10 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: currently active Linux kernel versions
References: <47B21F9A.8040904@wpkg.org> <20080213004951.GA29524@1wt.eu>
Date: Wed, 13 Feb 2008 08:28:06 +0100
In-Reply-To: <20080213004951.GA29524@1wt.eu> (Willy Tarreau's message of "Wed,
	13 Feb 2008 01:49:51 +0100")
Message-ID: <87k5l9pb7d.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> I would suggest stable - N-1 for most usages. 2.6.24.y is open, 2.6.23.y is
> supposed to be good. The advantage when you proceed like this is that you
> can jump from an older kernel to a more recent one which has already got its
> share of fixes and is still maintained for some time.
>
> Generally, I would trust Greg when he drops an old kernel, it means that he's
> confident enough in the next one.

Thanks for the useful (and concise) summary and sharing your thoughts
on the matter.  Now my only question is: how can I learn that Greg
updated or dropped a kernel without following LKML (which my time
unfortunately does not permit).  kernel-announce doesn't seem to
mention such events...
-- 
Regards,
Feri.
