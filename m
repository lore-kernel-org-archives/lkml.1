Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZIRQKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZIRQKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIRQKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:10:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:55662 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZIRQKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:10:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: d@teklibre.com (Dave Taht)
Subject: Re: [GIT PATCH] STAGING patches for 2.6.31-git
Date: Fri, 18 Sep 2009 09:47:32 -0600
Organization: Teklibre - http://www.teklibre.com
Message-ID: <87iqfgjluz.fsf@mahal.sjds.teklibre.org>
References: <20090915190520.GA834@kroah.com>
	<alpine.LFD.2.01.0909160813400.4950@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Gmane-NNTP-Posting-Host: wan58-233.cablenet.com.ni
X-PGP-FP: 
X-PGP: 
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
Cancel-Lock: sha1:q84FDQJQqwNnyqy8FQhe8NGyvog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 15 Sep 2009, Greg KH wrote:
>> 
>> Overall, we almost broke even with our cleanups and removals for what
>> was done here: 1267 files changed, 297615 insertions(+), 214568
>> deletions(-)
>
> Actually, it's
>
>  1253 files changed, 287789 insertions(+), 209389 deletions(-) Now,
> admittedly the 'copy' ones are dubious: it's picking up on the f*cking
> Ralink GPL copyright template, which is the bulk of those files.  But
> that in itself is interesting information, even if I personally find
> mindless copyright templates very annoying.

Snip

> while with it, you'll see examples of lots of cases of header files
> where there is more copyright header than actual content ;(
>
> 		Linus

kill-a-lawyer.el helps, at least on viewing the file, but that only
works in GNU emacs and xemacs. Last I heard you were a uemacs person.

Perhaps there could some sort of git diff washing mode that
ignores comments.


--
Dave Taht 
Postcards from the Bleeding Edge (http://the-edge.blogspot.com)

