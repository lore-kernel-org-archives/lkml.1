Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYDMWla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYDMWla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYDMWlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:41:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYDMWlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:41:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sclark46@earthlink.net
Subject: Re: Reporting bugs and bisection
Date: Mon, 14 Apr 2008 00:41:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       Tilman Schmidt <tilman@imap.cc>, Valdis.Kletnieks@vt.edu,
       Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <47FEADCB.7070104@rtr.ca> <20080413205406.GA9190@2ka.mipt.ru> <48028830.6020703@earthlink.net>
In-Reply-To: <48028830.6020703@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140041.34843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Stephen Clark wrote:
> Evgeniy Polyakov wrote:
> > On Sun, Apr 13, 2008 at 10:33:49PM +0200, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> >> Things like this are very disappointing and have a very negative impact on bug
> >> reporters.  We should do our best to avoid them.
> > 
> > Shit happens. This is a matter of either bug report or those who were in
> > the copy list. There are different people and different situations, in
> > which they do not reply.
> > 
> Well less shit would happen if developers would take the time to at least test 
> their patches before they were submitted. It like we will just have the poor 
> user do our testing for us. What kind of testing do developers do. I been a 
> linux user and have followed the LKML for a number of years and have yet to see
> any test plans for any submitted patches.

The (apparent) lack of test plans doesn't imply the patches not being tested,
actually.

My experience indicates that they are tested in the majority of cases.  Still,
sometimes they are not and that's when the most damage is done.

Thanks,
Rafael
