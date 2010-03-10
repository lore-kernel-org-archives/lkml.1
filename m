Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0CJD5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:57:48 -0500
Received: from www.telegraphics.com.au ([204.15.192.19]:63579 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab0CJD5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:57:44 -0500
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 22:57:44 EST
Date: Wed, 10 Mar 2010 14:48:13 +1100 (EST)
From: fthain@telegraphics.com.au
To: Michael Beardsworth <mbeards2@uoregon.edu>
cc: benh@kernel.crashing.org, grant.likely@secretlab.ca, geert@linux-m68k.org,
       monstr@monstr.eu, Nick Savage <nagaten@gmail.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: madness, was Re: [PATCH 2/2] Macintosh: fix coding style issues in
 adb.c This is a patch to the adb.c file that cleans up many warnings found
 by the checkpatch.pl tool
In-Reply-To: <1268172438-76422-1-git-send-email-mbeards2@uoregon.edu>
Message-ID: <alpine.LNX.2.00.1003101428460.4583@nippy.intranet>
References: <1268172438-76422-1-git-send-email-mbeards2@uoregon.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Mar 2010, Michael Beardsworth wrote:

> -	/* If a probe is in progress or we are sleeping, wait for it to complete */
> +	/* If a probe is in progress or we are sleeping, wait until complete */

If you must "fix" what aint broke, please try not to damage it. I'm sorry 
if your VT52 is limited to 80 cols, but IMNSHO this sort of effort is 
misguided.

Maybe I could point out again (I do this periodically) that checkpatch.pl 
is great but code that fails it is NOT always wrong.

"Check patch" is a good idea but "check existing code" is a waste of 
everyone's time.

Finn
