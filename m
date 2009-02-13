Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbZBMCRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbZBMCRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbZBMCQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:16:38 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:62368 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985AbZBMCQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:16:37 -0500
From: Junio C Hamano <junio@pobox.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Peter Zijlstra <peterz@infradead.org>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
References: <1234451714.10603.22.camel@laptop>
 <200902121825.35021.ioe-lkml@rameria.de>
 <20090212192104.GD15809@csclub.uwaterloo.ca>
Date: Thu, 12 Feb 2009 18:16:28 -0800
Message-ID: <7vmycrf5dv.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 57471130-F974-11DD-91E2-6F7C8D1D4FD0-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> On Thu, Feb 12, 2009 at 06:25:34PM +0100, Ingo Oeser wrote:
>> No, they are great, if you like to skip over a topic, you are not
>> interested in at all!
>> 
>> If you don't like it, just switch off thread in your mailer and
>> don't force this on everybody else!
>
> Actually if (as apparently many people seem to manage to do) you have a
> single starting email, with all the patches as replies to that first
> email, it looks a lot better, and is much easier to follow.
>
> Seperate threads would be bad.
>
> foobar patch 0 (usually a summary/overview)
> +-foobar patch 1
> +-foobar patch 2
> +-foobar patch 3
> +-foobar patch 4
> +-foobar patch 5
>
> is much nicer than
>
> foobar patch 0
> +-foobar patch 1
>   +-foobar patch 2
>     +-foobar patch 3
>       +-foobar patch 4
>         +-foobar patch 5
>
> which seems to be what git does itself.

I personally prefer the former, but as you hopefully all found out by now,
the choice between these two is just the matter of personal taste, and
there is no clear majority.

The default will not going to change.

