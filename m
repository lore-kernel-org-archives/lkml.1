Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZARWwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZARWwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZARWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:52:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZARWwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:52:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [git patches] libata hibernation fixes
Date: Sun, 18 Jan 2009 23:52:09 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: jeff@garzik.org, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901182125.04060.rjw@sisk.pl> <200901182159.13329.elendil@planet.nl>
In-Reply-To: <200901182159.13329.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901182352.10036.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009, Frans Pop wrote:
> On Sunday 18 January 2009, Rafael J. Wysocki wrote:
> > > I get two warnings when compiling your patch with this correction on
> > > top:
> >
> > Hm, there were more patches than one, so I'm not sure.  When I apply
> > all of them, I don't see these error, but perhaps I should resend the
> > entire series. Will do tomorrow.
> 
> It's possible that I do not have the very latest version of your patches. 
> If you send your latest version I'll check, and test them.
> 
> Thanks,
> FJP
> 
> P.S. .29-rc2 is failing both STR and STD on my HP 2510p :-(
>      Will mail details sometime this week.

There are some known problems, so please watch the next report of recent
regressions (most probably tomorrow).

Thanks,
Rafael
