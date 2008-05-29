Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYE2VQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYE2VQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbYE2VPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:15:49 -0400
Received: from xenotime.net ([66.160.160.81]:47849 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755985AbYE2VPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:15:49 -0400
Date: Thu, 29 May 2008 14:15:45 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Theodore Tso <tytso@mit.edu>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, mbligh@mbligh.org
Subject: Re: [Bug #10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 on X61s laptop
In-Reply-To: <200805292254.55248.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0805291414340.16189@shark.he.net>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <20080526192247.GA7515@mit.edu>
 <20080527125426.GJ7515@mit.edu> <200805292254.55248.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Rafael J. Wysocki wrote:

> On Tuesday, 27 of May 2008, Theodore Tso wrote:
> > Bug #10732 is now closed.  BTW, it seems d*mned strange that the
> > submitter of the bug doesn't have the power to close a bug without
> > first grabbing the bug as the bug-fixer, changing its state to
> > ASSIGNED, and *then* being allowed to close the bug.  Grumble,
> > bugzilla's !#@#?@ process straightjacket....
> 
> That depends on your account's access rights within the Bugzilla, which always
> have been a mystery to me.

Martin Bligh should be able to clear that mystery up.

-- 
~Randy
