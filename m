Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYCQAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYCQAVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYCQAVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 20:21:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:55395 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYCQAVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 20:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rRE4upNrW3qtwa5mkphhJKRyH2GCDbvh2khE+Kh+RRiKH2S+hjXs/d66apmtV4vQdG+CHZS/dr4/GzZpOEGHU+hqT+elxlDmUgf12a5Hmv0SeP2NsFMEIUU+nFRXRWAPAkAPELj8pR2/0VeCXzlFOG9q6jM4q5pZ2GxylEVlzYI=
Message-ID: <47DDB969.1060200@googlemail.com>
Date: Mon, 17 Mar 2008 01:20:57 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl>
In-Reply-To: <200803170018.52663.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

Hi,

> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10152
> Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
> Submitter	: Gabriel C <nix.or.die@googlemail.com>
> Date		: 2008-02-24 01:31 (22 days old)
> References	: http://lkml.org/lkml/2008/2/23/380
> 		  http://lkml.org/lkml/2008/2/24/281
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> 

Thomas do you want me to bisect ? 

Or do you have any patches I could try ( really does not matter how experimental they are ) ?

Rafael the bug report is saying x86-64 Component while my box is 32bit :) Could you please correct this ?

Best Regards 

Gabriel



