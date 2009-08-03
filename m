Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZHCPWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZHCPWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbZHCPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:22:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42182 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZHCPWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:22:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug #13815] emacs -nw compilation doesn't show the error message
Date: Mon, 3 Aug 2009 17:22:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.EVD.QdgdKB@chimera> <20090803025548.GA4403@skywalker>
In-Reply-To: <20090803025548.GA4403@skywalker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031722.29123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Aneesh Kumar K.V wrote:
> On Sun, Aug 02, 2009 at 08:58:27PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13815
> > Subject		: emacs -nw compilation doesn't show the error message
> > Submitter	: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Date		: 2009-07-23 06:22 (11 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d945cb9cce20ac7143c2de8d88b187f62db99bdc
> > 
> > 
> 
> This is fixed upstream (Linus's tree) by e043e42bdb66885b3ac10d27a01ccb9972e2b0a3

Thanks, closed.

Rafael
