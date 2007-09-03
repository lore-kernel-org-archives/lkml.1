Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXICGMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXICGMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 02:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXICGMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 02:12:15 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:37856 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXICGMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 02:12:15 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [4/4] 2.6.23-rc4: known regressions
Date: Mon, 3 Sep 2007 08:12:04 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: "Soeren Sonnenburg" <kernel@nn7.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>
References: <46D58CC6.4020605@googlemail.com> <1188470552.22467.8.camel@localhost> <6bffcb0e0709021533u1fd81db6pfb0d985d80f73995@mail.gmail.com>
In-Reply-To: <6bffcb0e0709021533u1fd81db6pfb0d985d80f73995@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709030812.05460.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 of September 2007, Michal Piotrowski wrote:
> Hi,
>
> On 30/08/07, Soeren Sonnenburg <kernel@nn7.de> wrote:
> > On Wed, 2007-08-29 at 17:27 +0200, Michal Piotrowski wrote:
> > > Power management
> > >
> > > Subject         : something broke resume from s2ram on mbp c1d (??? :))
> > > References      : http://lkml.org/lkml/2007/8/28/67
> > > Last known good : 2.6.23-rc3
> > > Submitter       : Soeren Sonnenburg <kernel@nn7.de>
> > > Caused-By       : ?
> > > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > > Status          : unknown
> > >
> > > Subject         : resume from ram much slower
> > > References      : http://lkml.org/lkml/2007/8/10/275
> > > Last known good : 2.6.23-rc1 ?
> > > Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
> > > Caused-By       : ?
> > > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > > Status          : problem is being debugged
> >
> > I am not sure whether the problem I am having is not the very same as
> > the one Arkadiusz is seeing. At least I've found resume from s2ram to be
> > working a couple of times. Only sometimes it took long to resume, that
> > is >30 seconds (around 5 - which I already consider long - is normal).
> >
> > anyway this this is with the closed source fglrx kernel module,
>
> Arkadiusz, are you using any of these binary crap modules?

No.

> Regards,
> Michal

ps. had no time to do bisecting

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
