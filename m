Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbXJIRNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbXJIRNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXJIRNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:13:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16513 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbXJIRM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:12:59 -0400
Date: Tue, 9 Oct 2007 10:11:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Documentation/patch-tags V2
Message-Id: <20071009101126.8b837436.randy.dunlap@oracle.com>
In-Reply-To: <32507.1191949182@lwn.net>
References: <32507.1191949182@lwn.net>
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

On Tue, 09 Oct 2007 10:59:42 -0600 Jonathan Corbet wrote:

> Here's a new version of the patch-tags document.  I've incorporated
> comments from Randy Dunlap, Stefan Richter, and Neil Brown, though I
> have retained, for now, the more verbose process discussion that Neil
> didn't like.
> 
> Comments?
> 
> jon
> 
> --
> 
> Document the tags used with kernel patches
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> 
> diff --git a/Documentation/patch-tags b/Documentation/patch-tags
> new file mode 100644
> index 0000000..d955fa2
> --- /dev/null
> +++ b/Documentation/patch-tags
> @@ -0,0 +1,81 @@
> +Patches headed for the mainline may contain a variety of tags documenting
> +who played a hand in (or was at least aware of) its progress.  All of these

	s/its/their/

> +tags have the form:
> +
> +	Something-done-by: Full name <email@address> [optional random stuff]
> +
> +These tags are:
> +

[snip]

> +Tested-by:	The patch has been successfully tested (in some
> +		environment) by the person named.  This tag informs
> +		maintainers that some testing has been performed and
> +		ensures credit for the testers.

?:	and provides a means to locate testers for future patches.

> +
> +
> +----
> +
> +Reviewer's statement of oversight, v0.02

[snip]

---
~Randy
