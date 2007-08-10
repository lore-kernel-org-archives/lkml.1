Return-Path: <linux-kernel-owner+w=401wt.eu-S941288AbXHJTNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941288AbXHJTNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbXHJTNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:13:38 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:17633 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479AbXHJTNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:13:37 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: resume from ram much slower
Date: Fri, 10 Aug 2007 21:13:24 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, "Pavel Machek" <pavel@ucw.cz>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <200708101848.37222.arekm@maven.pl> <6bffcb0e0708101034x44ef5bd0we6a94e398c30c511@mail.gmail.com> <200708102118.10576.rjw@sisk.pl>
In-Reply-To: <200708102118.10576.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708102113.25129.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 of August 2007, Rafael J. Wysocki wrote:
> On Friday, 10 August 2007 19:34, Michal Piotrowski wrote:
> > [S-T-R wizards CC'ed]
> >
> > On 10/08/07, Arkadiusz Miskiewicz <arekm@maven.pl> wrote:
> > > Hi,
> > >
> > > Starting 1-2 weeks ago I have very long resume from
> > > ram times. It takes more than 1 min to resume. Does anyone see such
> > > behaviour?
>
> No.
>
> Did it start after 2.6.23-rc1?

I'm almost sure that it was after rc1. Unfortunately I'm doing git pull too 
often so cannot be 100% sure.

> Greetings,
> Rafael



-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
