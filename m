Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbXLCQwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbXLCQwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXLCQwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:52:35 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56725 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXLCQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:52:34 -0500
Message-ID: <475433E1.6030208@oracle.com>
Date: Mon, 03 Dec 2007 08:50:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Clemens Koller <clemens.koller@anagramm.de>
CC: LKML List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/BUG-HUNTING whitespace cleanup, take 2
References: <475405A9.4030608@anagramm.de> <20071203083101.93141c4b.randy.dunlap@oracle.com> <47543339.7010104@anagramm.de>
In-Reply-To: <47543339.7010104@anagramm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller wrote:
> Randy Dunlap schrieb:
>  > On Mon, 03 Dec 2007 14:33:29 +0100 Clemens Koller wrote:
>  >
>  >> Just a little whitespace cleanup patch for Documentation/BUG-HUNTING.
>  >>
>  >> Signed-off-by: Clemens Koller <clemens.koller@anagramm.de>
>  >
>  >
>  > Mostly looks OK, except for the last chunk:  why delete that line?
>  > missing a + line?
>  >
>  >
>  > @@ -130,7 +130,6 @@ You will then do:
>  >              that makes the difference.
>  >
>  >  Finally, you take all the info that you have, kernel revisions, bug
>  > -description, the extent to which you have narrowed it down, and pass
>  >  that off to whomever you believe is the maintainer of that section.
>  >  A post to linux.dev.kernel isn't such a bad idea if you've done some
>  >  work to narrow it down.
> 
> Hmm... that was not intended, updated patch attached.
> 
> Thank you,
> 
> 
> ------------------------------------------------------------------------
> 
> Just a little whitespace cleanup patch for Documentation/BUG-HUNTING
> 
> Signed-off-by: Clemens Koller <clemens.koller@anagramm.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


Thanks.

-- 
~Randy
Features and documentation: http://lwn.net/Articles/260136/
