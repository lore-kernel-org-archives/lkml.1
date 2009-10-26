Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZJZWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZJZWHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZJZWHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:07:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZJZWHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:07:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: [Bug #14477] possible circular locking dependency in ISDN PPP
Date: Mon, 26 Oct 2009 23:09:21 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.9NF.9qe5KB@chimera> <4AE61C10.5030409@imap.cc>
In-Reply-To: <4AE61C10.5030409@imap.cc>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262309.21988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Tilman Schmidt wrote:
> Rafael J. Wysocki schrieb:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14477
> > Subject		: possible circular locking dependency in ISDN PPP
> > Submitter	: Tilman Schmidt <tilman@imap.cc>
> > Date		: 2009-10-18 22:16 (9 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125590423416087&w=4
> 
> Fixed by
> 
> http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=2bd9af046fdc10703b266b0f3b25423f0b7d703e

Thanks, closing.

Rafael
