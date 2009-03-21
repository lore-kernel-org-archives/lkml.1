Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZCUUS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZCUUS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZCUUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:18:50 -0400
Received: from blaine.gmane.org ([80.91.229.8]:48584 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZCUUSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:18:49 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@hugh.gmane.org>
Cc: Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Kernel Testers List 
	<public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "Jan Engelhardt" 
	<public-jengelh-nopoi9nDyk+ELgA04lAiVw@hugh.gmane.org>,
       "netdev" <public-netdev-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "Stephen Hemminger" 
	<public-shemminger-ZtmgI6mnKB3QT0dZR+AlfA@hugh.gmane.org>
Subject: Re: [Bug #12868] iproute2 and regressing "ipv6: convert tunnels to net_device_ops"
Organization: m
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
	<fnEpM0mQZjO.A.o3E.S8TxJB@chimera>
Date: Sat, 21 Mar 2009 21:16:48 +0100
In-Reply-To: <fnEpM0mQZjO.A.o3E.S8TxJB@chimera> (Rafael J. Wysocki's message
	of "Sat, 21 Mar 2009 18:07:29 +0100 (CET)")
Message-ID: <87iqm2hbrj.fsf@nemi.mork.no>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-TMDA-Confirmed: Sat, 21 Mar 2009 21:18:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12868
> Subject		: iproute2 and regressing "ipv6: convert tunnels to net_device_ops"
> Submitter	: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
> Date		: 2009-03-09 14:46 (13 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1326c3d5a4b792a2b15877feb7fb691f8945d203
> References	: http://marc.info/?l=linux-netdev&m=123660999632730&w=4


This is fixed by commit 1b1d8f73a44fe1796a73a97ebcb08cad18b97f07
currently in davem's net-2.6 tree.


Bjørn


