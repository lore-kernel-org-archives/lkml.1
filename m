Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbXJaJSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbXJaJSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXJaJS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:18:28 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4865 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbXJaJS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:18:27 -0400
Date: Wed, 31 Oct 2007 09:17:39 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Keiichi Kii <k-keiichi@bx.jp.nec.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 5/6] fix typo in SubmittingPatches
Message-ID: <20071031091739.GB12619@shadowen.org>
References: <20071031050954.GA3791@kroah.com> <1193807505-3821-1-git-send-email-gregkh@suse.de> <1193807505-3821-2-git-send-email-gregkh@suse.de> <1193807505-3821-3-git-send-email-gregkh@suse.de> <1193807505-3821-4-git-send-email-gregkh@suse.de> <1193807505-3821-5-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193807505-3821-5-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 10:11:44PM -0700, Greg Kroah-Hartman wrote:
> From: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> 
> Fix typo.
> 
> Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> Cc: Andy Whitcroft <apw@shadowen.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Andy Whitcroft <apw@shadowen.org>

> ---
>  Documentation/SubmittingPatches |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index a30dd44..681e2b3 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -464,8 +464,8 @@ section Linus Computer Science 101.
>  Nuff said.  If your code deviates too much from this, it is likely
>  to be rejected without further review, and without comment.
>  
> -Once significant exception is when moving code from one file to
> -another in this case you should not modify the moved code at all in
> +One significant exception is when moving code from one file to
> +another -- in this case you should not modify the moved code at all in
>  the same patch which moves it.  This clearly delineates the act of
>  moving the code and your changes.  This greatly aids review of the
>  actual differences and allows tools to better track the history of

-apw
