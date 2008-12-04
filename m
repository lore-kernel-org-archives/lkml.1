Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbYLDQhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbYLDQhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYLDQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:37:05 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:52771 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYLDQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:37:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vTTnBOqUZHtr3umnoSmwuuAaTBitMTyT+LUG1EbmPBWX7s8yYgMj/bi98hVuIlxfN3
         Zy7hSSutNOHqs9Jh4gYb55QbphLYbAKxffBHCjXJZtjV9aVGglHnljZUebQpWOS8No+U
         NYW9NKfB24Q16yY9czvyTuD5ao3b7KCR5zqD8=
Date: Thu, 4 Dec 2008 19:36:53 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Message-ID: <20081204163653.GA18534@localhost>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera> <TpbYvO5GPt.A.NtF.rHyNJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TpbYvO5GPt.A.NtF.rHyNJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Wed, Dec 03, 2008 at 11:40:29PM +0100]
| This message has been generated automatically as a part of a report
| of regressions introduced between 2.6.26 and 2.6.27.
| 
| The following bug entry is on the current list of known regressions
| introduced between 2.6.26 and 2.6.27.  Please verify if it still should
| be listed and let me know (either way).
| 
| 
| Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
| Subject		: kernel panic: softlockup in tick_periodic() ???
| Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
| Date		: 2008-09-11 16:46 (84 days old)
| References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
| Handled-By	: Thomas Gleixner <tglx@linutronix.de>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 		  Ingo Molnar <mingo@elte.hu>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 
|

info needed

		- Cyrill -
