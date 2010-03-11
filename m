Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0CKVpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:45:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:34186 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0CKVpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:45:45 -0500
Subject: Re: madness, was Re: [PATCH 2/2] Macintosh: fix coding style
 issues in adb.c This is a patch to the adb.c file that cleans up many
 warnings found by the checkpatch.pl tool
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: fthain@telegraphics.com.au
Cc: Michael Beardsworth <mbeards2@uoregon.edu>, grant.likely@secretlab.ca,
       geert@linux-m68k.org, monstr@monstr.eu, Nick Savage <nagaten@gmail.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1003101428460.4583@nippy.intranet>
References: <1268172438-76422-1-git-send-email-mbeards2@uoregon.edu>
	 <alpine.LNX.2.00.1003101428460.4583@nippy.intranet>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 08:45:10 +1100
Message-ID: <1268343910.22204.710.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 14:48 +1100, fthain@telegraphics.com.au wrote:
> On Tue, 9 Mar 2010, Michael Beardsworth wrote:
> 
> > -	/* If a probe is in progress or we are sleeping, wait for it to complete */
> > +	/* If a probe is in progress or we are sleeping, wait until complete */
> 
> If you must "fix" what aint broke, please try not to damage it. I'm sorry 
> if your VT52 is limited to 80 cols, but IMNSHO this sort of effort is 
> misguided.
> 
> Maybe I could point out again (I do this periodically) that checkpatch.pl 
> is great but code that fails it is NOT always wrong.
> 
> "Check patch" is a good idea but "check existing code" is a waste of 
> everyone's time.

Amen !

Cheers,
Ben.


