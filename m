Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbZE2Vc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbZE2Vc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZE2Vcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:32:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbZE2Vcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:32:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
Date: Fri, 29 May 2009 23:32:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1243625720.4426.0.camel@plop> <200905292147.05395.rjw@sisk.pl> <e8ca35370905291254o759dc18x8a6b318228c8ba4e@mail.gmail.com>
In-Reply-To: <e8ca35370905291254o759dc18x8a6b318228c8ba4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905292332.57700.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 May 2009, Pascal Terjan wrote:
> 2009/5/29 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday 29 May 2009, Pascal Terjan wrote:
> >> (Resending because of wrong To:, sorry for the duplicate)
> >>
> >> We have a machine here where hard disk is no longer detected at boot
> >> time with 2.6.29.3 (it happens only on kernels with HIGHMEM4G + PAE and
> >> not on the same one with HIGHMEM64G).
> >>
> >> Motherboard is ECS PF22 Extreme
> >>
> >> bisect blames this commit:
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=3b442bfc78d351343fa539c63afde75d7b134316
> >
> > Would it be possible to check if the current mainline works correctly?
> >
> 
> I'll do that on Tuesday (the machine is in the office)

Great, thanks.

Rafael
