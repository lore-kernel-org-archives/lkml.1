Return-Path: <linux-kernel-owner+w=401wt.eu-S944740AbXHMUhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944740AbXHMUhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbXHMUhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:37:39 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:8213 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbXHMUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S3nTh4n4qin4+CXbf7VTE01ufNW4ACPciT5h6gqgnlCxseGAkmj7iShuF7CHzLSOxo8o3vDx0Pmw7qjoVp2KbyM8okntGVuknD0PXM28haBWenhu+bWgohl8b3WRUHyyQRTe0TIlz9UEw7Mgj3NYPJwdXiUojMAaKVLYrUrl8Zg=
Message-ID: <524f69650708131337i5f9f9761gea2600c1c1be3be7@mail.gmail.com>
Date: Mon, 13 Aug 2007 15:37:36 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Andrew Bartlett" <abartlet@samba.org>
Subject: Re: [PATCH] [123/2many] MAINTAINERS - COMMON INTERNET FILE SYSTEM (CIFS)
Cc: joe@perches.com, torvalds@linux-foundation.org, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, akpm@linux-foundation.org
In-Reply-To: <1187002400.22086.6.camel@dragonlady>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff94b.cqAV08ZZtCVJZMCU%joe@perches.com>
	 <1187002400.22086.6.camel@dragonlady>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Andrew Bartlett <abartlet@samba.org> wrote:
> On Sun, 2007-08-12 at 23:25 -0700, joe@perches.com wrote:
> > Add file pattern to MAINTAINER entry
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 1c014f1..5144e4e 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1201,6 +1201,7 @@ L:      samba-technical@lists.samba.org
> >  W:   http://us1.samba.org/samba/Linux_CIFS_client.html
> >  T:   git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
> >  S:   Supported
> > +F:   fs/cifs/
>
> No comment on the F:, but the L: entry here is interesting.  Is
> samba-technical really the right list for cifs-vfs patches?  Aside from
> being CC'ed on such patches, I've never seen discussion of them on the
> Samba mailing lists.
>
> Steve: Shouldn't that be linux-cifs-client?

linux-cifs-client is mentioned on the L: entry immediately before the
samba-technical one so no change seems to be needed for that.

I updated the W: line to point to the preferred URL
(http://linux-cifs.samba.org)

Adding an F: entry in the future is fine by me

-- 
Thanks,

Steve
