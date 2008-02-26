Return-Path: <linux-kernel-owner+w=401wt.eu-S1761754AbYBZOTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761754AbYBZOTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYBZOTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:19:11 -0500
Received: from spiffy.freedom.ind.br ([201.35.65.91]:44483 "EHLO
	freedom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589AbYBZOTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:19:10 -0500
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: oops when using git gc --auto
References: <87tzjvhmy7.fsf@ossystems.com.br>
	<200802270033.31297.nickpiggin@yahoo.com.au>
From: Otavio Salvador <otavio@debian.org>
Organization: O.S. Systems Ltda.
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Tue, 26 Feb 2008 11:21:39 -0300
In-Reply-To: <200802270033.31297.nickpiggin@yahoo.com.au> (Nick Piggin's message of "Wed\, 27 Feb 2008 00\:33\:31 +1100")
Message-ID: <87lk57yf0s.fsf@ossystems.com.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Wednesday 27 February 2008 00:22, Otavio Salvador wrote:
>> Hello,
>>
>> Today I got this oops, someone has an idea of what's going wrong?
>>
>> Unable to handle kernel paging request at 0000020000000000 RIP:
>>  [<ffffffff802735c3>] find_get_pages+0x3c/0x69
>
> At this point, the most likely candidate is a memory corruption
> error, probably hardware. Can you run memtest86 for a few hours
> to get a bit more confidence in the hw (preferably overnight)?

Those memories are new, but I can try. No problem. Will get back to
you by tomorrow.

> I did recently see another quite similar corruption in the
> pagecache radix-tree, though. Coincidence maybe?

I hope not.

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
