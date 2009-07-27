Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZG0Wlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZG0Wlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZG0Wlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:41:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37068 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZG0Wlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:41:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma@tdiedrich.de>
Subject: Re: [Bug #13826] thinkpad boots with backlight low
Date: Tue, 28 Jul 2009 00:42:26 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Pavel Machek <pavel@ucw.cz>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.KtC.THObKB@chimera> <20090727110651.GA4496@yamamaya.is-a-geek.org>
In-Reply-To: <20090727110651.GA4496@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280042.27190.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Tobias Diedrich wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Yes, this still applies to 2.6.31-rc4.
> If I  don't add brightness_mode=2 the backlight controls don't work
> properly.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13826
> > Subject		: thinkpad boots with backlight low
> > Submitter	: Pavel Machek <pavel@ucw.cz>
> > Date		: 2009-07-15 15:13 (12 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124756359126830&w=4
> > Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Thanks for the update.

Rafael
