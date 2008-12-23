Return-Path: <linux-kernel-owner+w=401wt.eu-S1751481AbYLWLjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbYLWLjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 06:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYLWLjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 06:39:16 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:31690 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbYLWLjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 06:39:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgBACtcUEnDDR8P/2dsb2JhbAAIgxS7SViRFYZD
Message-ID: <4950CDE1.5070501@belbone.be>
Date: Tue, 23 Dec 2008 12:39:13 +0100
From: =?UTF-8?B?Q8OpZHJpYyBHb2Rpbg==?= <cedric@belbone.be>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>,
       Keith Packard <keithp@keithp.com>
Subject: Re: [Bug #12178] Xorg crash at first start
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <vy-yJy0f3YP.A.vMB.caYTJB@chimera>
In-Reply-To: <vy-yJy0f3YP.A.vMB.caYTJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12178
> Subject		: Xorg crash at first start
> Submitter	: Cédric Godin <cedric@belbone.be>
> Date		: 2008-12-04 14:26 (17 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=52440211dcdc52c0b757f8b34d122e11b12cdd50
> References	: http://marc.info/?l=linux-kernel&m=122840082828098&w=4
>
>
>   
It seems that the bug #12216 is the same bug. I tested the patch posted
in it and everything is back to normal. Many thanks.
