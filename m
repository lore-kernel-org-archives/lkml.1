Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXHRRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXHRRAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXHRQ7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 12:59:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58577 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbXHRQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 12:59:51 -0400
Date: Sat, 18 Aug 2007 10:05:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS
Message-Id: <20070818100505.6a3cd83a.randy.dunlap@oracle.com>
In-Reply-To: <1187420935.4200.16.camel@localhost>
References: <1187420935.4200.16.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007 00:08:54 -0700 Joe Perches wrote:

> Added patterns to describe files maintained.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d3a0684..d7fe1c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19,40 +19,44 @@ trivial patch so apply some common sense.
>  3.	Make sure your changes compile correctly in multiple
>  	configurations. In particular check that changes work both as a
>  	module and built into the kernel.
>  
>  4.	When you are happy with a change make it generally available for
>  	testing and await feedback.
>  
>  5.	Make a patch available to the relevant maintainer in the list. Use
>  	'diff -u' to make the patch easy to merge. Be prepared to get your
>  	changes sent back with seemingly silly requests about formatting
>  	and variable names.  These aren't as silly as they seem. One
>  	job the maintainers (and especially Linus) do is to keep things
>  	looking the same. Sometimes this means that the clever hack in
>  	your driver to get around a problem actually needs to become a
>  	generalized kernel feature ready for next time.
>  
>  	PLEASE check your patch with the automated style checker
>  	(scripts/checkpatch.pl) to catch trival style violations.
>  	See Documentation/CodingStyle for guidance here.
>  
> +	PLEASE include the appropriate maintainers and developers
> +	that have modified files touched by your patch by using the

s/that/who/

> +	automated CC generator (scripts/get_maintainer.pl)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
