Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZHCC4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZHCC4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 22:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZHCC4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 22:56:04 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:43979 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZHCC4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 22:56:02 -0400
Date: Mon, 3 Aug 2009 08:25:49 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [Bug #13815] emacs -nw compilation doesn't show the error
	message
Message-ID: <20090803025548.GA4403@skywalker>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.EVD.QdgdKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iZB3Pj-uj3M.A.EVD.QdgdKB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 08:58:27PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13815
> Subject		: emacs -nw compilation doesn't show the error message
> Submitter	: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date		: 2009-07-23 06:22 (11 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d945cb9cce20ac7143c2de8d88b187f62db99bdc
> 
> 

This is fixed upstream (Linus's tree) by e043e42bdb66885b3ac10d27a01ccb9972e2b0a3

-aneesh
