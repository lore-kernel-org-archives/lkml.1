Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYE0Mz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYE0Mz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 08:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYE0MzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 08:55:21 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54723 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbYE0MzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 08:55:20 -0400
Date: Tue, 27 May 2008 08:54:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10732] REGRESSION: 2.6.26-rc2-git4: X server failed
	start on X61s laptop
Message-ID: <20080527125426.GJ7515@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hugh Dickins <hugh@veritas.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.VVD.WeIOIB@albercik> <Pine.LNX.4.64.0805261115470.3720@blonde.site> <20080526192247.GA7515@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526192247.GA7515@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug #10732 is now closed.  BTW, it seems d*mned strange that the
submitter of the bug doesn't have the power to close a bug without
first grabbing the bug as the bug-fixer, changing its state to
ASSIGNED, and *then* being allowed to close the bug.  Grumble,
bugzilla's !#@#?@ process straightjacket....

							- Ted
