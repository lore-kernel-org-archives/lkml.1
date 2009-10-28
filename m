Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZJ1D4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZJ1D4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZJ1D4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:56:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47149 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbZJ1D43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:56:29 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Peter Teoh" <htmldeveloper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14408] sysctl check failed
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	<6dRYo8ss7vL.A.74F.Ore5KB@chimera>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Oct 2009 20:56:29 -0700
In-Reply-To: <6dRYo8ss7vL.A.74F.Ore5KB@chimera> (Rafael J. Wysocki's message of "Mon\, 26 Oct 2009 19\:55\:56 +0100 \(CET\)")
Message-ID: <m1k4ygcgsy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).

I believe Andrew has the fix in the -mm tree.

This is a bug but not a regression as the sysctl_check code had this bug from
day one.

Eric
