Return-Path: <linux-kernel-owner+w=401wt.eu-S1765087AbXGKRbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765087AbXGKRbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXGKRbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:31:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:51901 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbXGKRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YjCefIMN7PFljSetZ22TrkqhlAJ6SyiZonIeEsdbCPuMsOs/dX4HusPt8So5aJYI1rAz5rwJSkxMTa5lJhFxlVXGC1OJQlE8bexlwEPf5nZ25XvgwvFGleg5R4w2+0JbE10iGYKc7OItd7X0wwOFGFe3R9lrFmzvWnSJV3ZWEGM=
Message-ID: <9a8748490707111031x4de0d2efp6ee8e3bb3b2f6f5a@mail.gmail.com>
Date: Wed, 11 Jul 2007 19:31:29 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Quite trivial patches listed as needing re-review? (was: Re: -mm merge plans for 2.6.23)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
[snip]
> submitchecklist-update-fix-spelling-error.patch
...
>
>  Merge, subject to re-review.
>
...
> add-missing-files-and-dirs-to-00-index-in-documentation.patch
> remove-the-last-few-umsdos-leftovers.patch
...
> Merge, subject to re-review.
[snip]

Can't speak for all the other patches, but the 3 listed above are
quite trivial and hardly touch any code at all. I'm wondering why they
are not just pushed upstream, but instead listed as "subject to
re-review" ?

Am I supposed to do anything to get them merged?


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
