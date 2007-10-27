Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXJ0DvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXJ0DvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbXJ0Du6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:50:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32086 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXJ0Du5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:50:57 -0400
Date: Fri, 26 Oct 2007 20:50:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/2] fix typo in SubmittingPatches
Message-Id: <20071026205009.24ec2d83.randy.dunlap@oracle.com>
In-Reply-To: <47218E80.50700@bx.jp.nec.com>
References: <47218DBC.8070404@bx.jp.nec.com>
	<47218E80.50700@bx.jp.nec.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 15:51:44 +0900 Keiichi KII wrote:

> From: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> 
> Fix typo.
> 
> Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> Cc: Andy Whitcroft <apw@shadowen.org>
> ---
> Index: trunk/Documentation/SubmittingPatches
> ===================================================================
> --- trunk.orig/Documentation/SubmittingPatches
> +++ trunk/Documentation/SubmittingPatches
> @@ -464,7 +464,7 @@ section Linus Computer Science 101.
>  Nuff said.  If your code deviates too much from this, it is likely
>  to be rejected without further review, and without comment.
>  
> -Once significant exception is when moving code from one file to
> +One significant exception is when moving code from one file to
>  another in this case you should not modify the moved code at all in
>  the same patch which moves it.  This clearly delineates the act of
>  moving the code and your changes.  This greatly aids review of the

That first sentence is still broken.  It should be more like this,
with either a ":" or ";" or " -- " between clauses:

One significant exception is when moving code from one file to
another -- in this case you should not modify the moved code at all in
the same patch which moves it.


---
~Randy
