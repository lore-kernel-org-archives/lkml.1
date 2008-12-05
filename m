Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYLETC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYLETC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYLETCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:02:20 -0500
Received: from flusers.ccur.com ([12.192.68.2]:49971 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753421AbYLETCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:02:19 -0500
Date: Fri, 5 Dec 2008 14:01:47 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linux API <linux-api@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ABI Documentation for /proc/timer_list, v2
Message-ID: <20081205190147.GC22787@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <20081126164845.GA17394@tsunami.ccur.com> <20081126170715.GA28422@kroah.com> <20081126173410.GA17879@tsunami.ccur.com> <20081126173931.GA1636@kroah.com> <20081126210613.GA20529@tsunami.ccur.com> <cfd18e0f0811281337j57166b4cv54e05296a779252e@mail.gmail.com> <20081201181106.GA18320@tsunami.ccur.com> <493960F2.6070102@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493960F2.6070102@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,
Thanks for taking the time to review this.  I get the
impression, though, that the corresponding patch that
creates the 0.5 version of /proc/timer_list is not going
to be accepted.  Perhaps I should strip down this ABI
patch to document just the existing 0.4 /proc/timer_list.

Regards,
Joe

