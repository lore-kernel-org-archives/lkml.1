Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZJUAoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZJUAoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 20:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZJUAoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 20:44:00 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47460 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZJUAoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 20:44:00 -0400
Subject: Re: [ntp:hackers] ntp-dev-4.2.5p235-RC build failure: MOD_NANO not
 #defined
From: john stultz <johnstul@us.ibm.com>
To: James Cloos <cloos@jhcloos.com>
Cc: davehart_gmail_exchange_tee@davehart.net, hackers@lists.ntp.org,
       linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <m3aazlk5vz.fsf@lugabout.jhcloos.org>
References: <m3iqe9kj18.fsf@lugabout.jhcloos.org>
	 <85d954180910201227q528ff210v575df8c1f83e9ada@mail.gmail.com>
	 <1f1b08da0910201345w61f1bb4yb99b5f052ea77ac4@mail.gmail.com>
	 <m3aazlk5vz.fsf@lugabout.jhcloos.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Oct 2009 17:43:58 -0700
Message-Id: <1256085838.3346.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 19:22 -0400, James Cloos wrote:
> >>>>> "john" == john stultz <johnstul@us.ibm.com> writes:
> 
> john> The kernel has already been fixed, but glibc still needs to pick up the change.
> john> See the kernel commit here:
> john> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=c95b4502ad7fe8f3b9954aec794b00ac0046ab3a
> 
> Ah.  I only looked in my (up to date) clone of Linus’ tree; I didn’t
> check the trees-to-pull.

Huh. I guess I was mistaken and had mixed up my bookmarks. You're right,
I thought it was already upstream, but I've been looking at the wrong
tree. The patch is not yet in mainline.

> Will that be part of a pull request for the current rc or only for the
> next merge window?

Ingo, any eta on when commit c95b4502ad7fe8f3b9954aec794b00ac0046ab3a
will be pushed? Not sure how it got missed this last cycle.

thanks
-john


