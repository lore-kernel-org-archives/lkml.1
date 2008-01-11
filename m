Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbYAKWlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbYAKWlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761106AbYAKWlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:41:44 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:38783 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760101AbYAKWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:41:43 -0500
Date: Fri, 11 Jan 2008 14:39:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Documentation/ patches
Message-Id: <20080111143937.6daef35a.randy.dunlap@oracle.com>
In-Reply-To: <20080111221749.GN28043@fieldses.org>
References: <1200088216-9211-1-git-send-email-bfields@citi.umich.edu>
	<20080111140314.dd626be3.randy.dunlap@oracle.com>
	<20080111221749.GN28043@fieldses.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 17:17:49 -0500 J. Bruce Fields wrote:

> On Fri, Jan 11, 2008 at 02:03:14PM -0800, Randy Dunlap wrote:
> > On Fri, 11 Jan 2008 16:50:12 -0500 J. Bruce Fields wrote:
> > 
> > > 
> > > I've had these (fairly trivial) patches sitting around for a while just
> > > because I had no idea who to send them to.
> > > 
> > > So I figure that means they, err, go to you?
> > > 
> > > Apologies if not.
> > 
> > All 4 Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Could we do something like this?
> 
> --b.
> 
> >From 05873d4263eb50ac3b7f1d32e9bc4ec3a74f65a0 Mon Sep 17 00:00:00 2001
> From: J. Bruce Fields <bfields@citi.umich.edu>
> Date: Fri, 11 Jan 2008 17:14:19 -0500
> Subject: [PATCH] MAINTAINERS: Clarify scope of documentation maintainership
> 
> Randy Dunlap <randy.dunlap@oracle.com> appears to review any
> documentation patches, not just those that raise Docbook issues.
> 
> Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 79c711e..2d10ca8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1306,7 +1306,7 @@ M:	juergh@gmail.com
>  L:	lm-sensors@lm-sensors.org
>  S:	Maintained
>  
> -DOCBOOK FOR DOCUMENTATION
> +DOCUMENTATION
>  P:	Randy Dunlap
>  M:	rdunlap@xenotime.net
>  S:	Maintained
> -- 

Yes, I've been tempted to do that for quite some time.

The LF (TAB) also continues to try to have someone work on kernel
documentation, so we could see changes/additions to this, but this
is OK for now.

Thanks.

---
~Randy
