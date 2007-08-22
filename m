Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXHVW6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXHVW6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762735AbXHVW6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:58:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3869 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762503AbXHVW6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:58:43 -0400
Subject: Re: [PATCH] MAINTTAINERS: update DCO info
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20070822082421.5c20b3da.randy.dunlap@oracle.com>
References: <20070822082421.5c20b3da.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 15:57:56 -0700
Message-Id: <1187823476.24819.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 08:24 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Update URL for DCO (old URL is invalid).
> Also, point to SubmittingPatches for the current DCO.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  MAINTAINERS |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.23-rc3-git2.orig/MAINTAINERS
> +++ linux-2.6.23-rc3-git2/MAINTAINERS
> @@ -45,8 +45,11 @@ trivial patch so apply some common sense
>  
>  	PLEASE remember that submissions must be made under the terms
>  	of the OSDL certificate of contribution
> -	(http://www.osdl.org/newsroom/press_releases/2004/2004_05_24_dco.html)
> +	(http://old.linux-foundation.org/newsroom/press_releases/2004/2004_05_24_dco.html)
>  	and should include a Signed-off-by: line.
> +	The current certificate is also documented in
> +	Documentation/SubmittingPatches as the Developer's Certificate
> +	of Origin (DCO).

Why have an external link which may go out of date
when we already have the cert?

It's really short, we could just quote it.

Maybe it should be a separate file
Documentation/Developer_Certificate_of_Origin
and referenced directly.

	Developer's Certificate of Origin 1.1

	By making a contribution to this project, I certify that:

	(a) The contribution was created in whole or in part by me and I
	    have the right to submit it under the open source license
	    indicated in the file; or

	(b) The contribution is based upon previous work that, to the best
	    of my knowledge, is covered under an appropriate open source
	    license and I have the right under that license to submit that
	    work with modifications, whether created in whole or in part
	    by me, under the same open source license (unless I am
	    permitted to submit under a different license), as indicated
	    in the file; or

	(c) The contribution was provided directly to me by some other
	    person who certified (a), (b) or (c) and I have not modified
	    it.

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.


