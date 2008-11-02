Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYKBV0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYKBV0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYKBV0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:26:09 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52668 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754069AbYKBV0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:26:07 -0500
Date: Sun, 2 Nov 2008 16:26:04 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Meelis Roos <mroos@linux.ee>, Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [Bug #11937] ext3 __log_wait_for_space: no transactions
Message-ID: <20081102212604.GK8134@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Meelis Roos <mroos@linux.ee>, Simon Arlott <simon@fire.lp0.eu>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.1OE.sjeDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wOAXuecskPD.A.1OE.sjeDJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 05:07:09PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11937
> Subject		: ext3 __log_wait_for_space: no transactions
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2008-10-30 9:49 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=122536026105643&w=4
> Handled-By	: Theodore Tso <tytso@mit.edu>

Yep, should still be listed.  As mentioned in the BZ entry, there is a
proposed patch here:

	 http://lkml.org/lkml/2008/11/1/61

I'm waiting for feedback from the people who have run accross the bug.

    	    		      	  	     - Ted

