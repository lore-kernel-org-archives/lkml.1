Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYKCHXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYKCHXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYKCHW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:22:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:63318 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYKCHW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xpMgRfHUlL4eLc08/Vz1zSmr4ZyAMtdwSgO1diiIC9k+3q0NXUhsmUnzmf8Cf+1ZMz
         /blX8odoZtGoWchaKgc4ODQxX+vxrgJ98SZc59UzPHvXy4RPgrEi4OBikWNIsdzO1/c4
         w82bX9dH/iGhsaKC08ZOssaHnqkElqpnBlbqE=
Date: Mon, 3 Nov 2008 10:22:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Message-ID: <20081103072251.GA16459@localhost>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera> <4xS1r6m15_B.A.93B.LweDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4xS1r6m15_B.A.93B.LweDJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Sun, Nov 02, 2008 at 05:49:34PM +0100]
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
| Date		: 2008-09-11 16:46 (53 days old)
| References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
| Handled-By	: Thomas Gleixner <tglx@linutronix.de>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 		  Ingo Molnar <mingo@elte.hu>
| 
| 

Still in progress

		- Cyrill -
