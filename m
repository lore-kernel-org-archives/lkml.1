Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbXGDBIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbXGDBIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbXGDBIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:08:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:7025 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbXGDBId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:08:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kqaKaLv3tSFmR5BZIHI1cVhn6bHj8dyZiguDq8Xt8a3acg+1TU1OOR/5YWQN6g3gWahkid5IqnGXVFs2+ma1NyAq+CvsAN6xrBDHU+7FWB6do6oEkaQGU8S4b8ufS7OMusDrPPvAJmr5eeFRFNV/vwTeZPjHIY3vyN3FymLpGHE=
Message-ID: <9a8748490707031808m73093345i141b772b283a9d04@mail.gmail.com>
Date: Wed, 4 Jul 2007 03:08:32 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH][Documentation][resend] Add missing files and dirs to 00-INDEX in Documentation/
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, trivial@kernel.org,
       "Rob Landley" <rob@landley.net>
In-Reply-To: <20070703125852.0172a588.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707010106.00181.jesper.juhl@gmail.com>
	 <20070703125852.0172a588.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 1 Jul 2007 01:05:59 +0200
> Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
> > This patch adds descriptions for a number of missing files and directories
> > to the Documentation/00-INDEX file.
> > People really should learn to keep this file up-to-date when adding or
> > moving documentation...
>
> Or just delete it.  Does anyone use it?
>
I know I use it (that's partly why I noticed that stuff was missing).

Sure we could just delete it and the loss wouldn't be too great, but
in any case, as long as we do have that file in there I feel that it
ought to be up-to-date.

> That's Rob's problem, I guess.
>
Let's leave final judgement of the patch to Rob then. That's fine by me.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
