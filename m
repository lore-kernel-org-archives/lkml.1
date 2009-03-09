Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZCIUo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZCIUo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCIUoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:44:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44670 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZCIUop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:44:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
Cc: linux-aio <linux-aio@kvack.org>, michael.kerrisk@gmail.com,
       zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [patch] man-pages: add documentation about the memlock  implications of io_setup
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
	<x49zlfud6w7.fsf@segfault.boston.devel.redhat.com>
	<c49095e30903090948n2d015516t480e917c36943001@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 09 Mar 2009 16:44:01 -0400
In-Reply-To: <c49095e30903090948n2d015516t480e917c36943001@mail.gmail.com>
	(Michael Kerrisk's message of "Tue, 10 Mar 2009 05:48:07 +1300")
Message-ID: <x494oy2ctpq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <michael.kerrisk@googlemail.com> writes:

> [RESEND: Really CC+=Vegard Nossum, this time, and += mtk.manpages@, as well]
>
> Hi Jeff,
>
> Note that my address for man-pages is mtk.manpages@gmail.com.

Sorry about that!

> On Tue, Mar 10, 2009 at 4:59 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Hi,
>>
>> This patch, against man-pages-3.19, adds verbiage surrounding the newly
>> proposed accounting of pinned aio completion ring pages against the
>> memlock rlimit.  It also fixes up a few references to aio_context_t
>> (which should be io_context_t).  Sorry for conflating the two, I can
>> break it apart if needed.
>
> Breaking apart really would be better.  Could you resubmit (to
> mtk.manpages@, and CC linux-man@vger) please?

Sure thing.  I'll address your question when I resubmit.

Thanks!

Jeff
