Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbYJ1P0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbYJ1P0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYJ1PZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:25:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37727 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYJ1PZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:25:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Date: Tue, 28 Oct 2008 16:30:27 +0100
User-Agent: KMail/1.9.9
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Soeren Sonnenburg" <kernel@nn7.de>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810272350.29429.rjw@sisk.pl> <1ba2fa240810271612g72bb2b08p6ebab9f6f02f5b98@mail.gmail.com>
In-Reply-To: <1ba2fa240810271612g72bb2b08p6ebab9f6f02f5b98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281630.28389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 of October 2008, Tomas Winkler wrote:
> h
> 
> On Tue, Oct 28, 2008 at 12:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, 27 of October 2008, Tomas Winkler wrote:
> >> On Tue, Oct 28, 2008 at 12:28 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> >> > On Mon 27.Oct'08 at 23:07:00 +0200, Tomas Winkler wrote:
> >> >>[...]
> >> >>
> >> >> Can someone try this one (it might be space broken I've just pasted
> >> >> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
> >> >> (latest linux-2.6.git)
> >> >
> >> >
> >> > Yes, this one also works for me (I applied it manually).
> >> Good, this was actually part of some older and bigger patch I wasn't
> >> aware it has this affect. It has some millage in iwl5000 branch.
> >> RFKIll went through some changes in the mainline so it wasn't merged yet.
> >
> > Are you going to push this patch upstream now?  It's quite important to get
> > this resume regression fixed ASAP.
> 
> Definitely I would post it to wireless and stable.

Please send a CC to me too.

Thanks,
Rafael
