Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYJZLVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYJZLVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYJZLU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:20:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:48006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYJZLU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NF2i/IYIcoslj6Lg+XLWb+abmyYx1Na5/nSJaruumlMGtB7wj8m93J9PpUKfD/vXA7
         /eDU0ZFd4Z136gw5BgKoqmbf2KAflD8vZKU2GE+mCBLRlEzN7PzWpnXwt1/S2ePFklJm
         NrwXm1zqlDOU8kfK4aW+U3oS9gcgHdDJak5XY=
Date: Sun, 26 Oct 2008 14:20:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Message-ID: <20081026112047.GC7639@localhost>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera> <gLTYxg3cC1.A.csF.wK6AJB@chimera> <20081026071132.GB7639@localhost> <200810261203.43348.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810261203.43348.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Sun, Oct 26, 2008 at 12:03:42PM +0100]
| On Sunday, 26 of October 2008, Cyrill Gorcunov wrote:
| > [Rafael J. Wysocki - Sat, Oct 25, 2008 at 11:07:49PM +0200]
| > | This message has been generated automatically as a part of a report
| > | of regressions introduced between 2.6.26 and 2.6.27.
| > | 
| > | The following bug entry is on the current list of known regressions
| > | introduced between 2.6.26 and 2.6.27.  Please verify if it still should
| > | be listed and let me know (either way).
| > | 
| > | 
| > | Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
| > | Subject		: kernel panic: softlockup in tick_periodic() ???
| > | Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
| > | Date		: 2008-09-11 16:46 (45 days old)
| > | References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
| > | Handled-By	: Thomas Gleixner <tglx@linutronix.de>
| > | 		  Cyrill Gorcunov <gorcunov@gmail.com>
| > | 		  Ingo Molnar <mingo@elte.hu>
| > | 
| > | 
| > 
| > It's still there but with completely out of 'subject' problems.
| 
| OK, what subject will be more appropriate?
| 
| Rafael
| 

Not sure Rafael -- now Joshua have different type
of kernel errors -- and NULL deref and do_IRQ hang.
Joshua?

		- Cyrill -
