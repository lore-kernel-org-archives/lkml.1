Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZKQWtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZKQWtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbZKQWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:49:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbZKQWtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:49:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Norbert Preining <preining@logic.at>
Subject: Re: [Bug #14618] OOM killer, page fault
Date: Tue, 17 Nov 2009 23:51:00 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Minchan Kim <minchan.kim@gmail.com>, gg@gandalf.dynalias.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <28c262360911170040r4313ca2bs9716b9271946f082@mail.gmail.com> <20091117091905.GA23205@gandalf.dynalias.org>
In-Reply-To: <20091117091905.GA23205@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172351.00189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Norbert Preining wrote:
> On Tue, 17 Nov 2009, Minchan Kim wrote:
> > I think we can ignore this bug.
> 
> Agreed. It is so hard to reproduce, and might be some other reason for
> that. 
> 
> > As I know, It happens very rarely. Norbert, right?
> 
> Yes definitely.
> 
> > So I think It would be better to ignore this bug
> > until we can meet similar report again.
> 
> Agreed, please close or whatever.

Thanks for the update, I'm going to close it.

Rafael
