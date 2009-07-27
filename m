Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZG0WxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZG0WxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZG0WxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:53:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZG0WxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:53:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: [Bug #13846] Possible regression in rt61pci driver
Date: Tue, 28 Jul 2009 00:53:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.eMB.9GObKB@chimera> <c6b1100b0907270227r4ab5a0b1q410160f92c94eae9@mail.gmail.com>
In-Reply-To: <c6b1100b0907270227r4ab5a0b1q410160f92c94eae9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280053.59132.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Chris Clayton wrote:
> 2009/7/26 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> 
> This bug should remain open, although we are, I think, getting closer
> to the cause, which seems to be related to some interaction between
> the rt61 driver and mac80211 power saving.
> 
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13846
> > Subject         : Possible regression in rt61pci driver
> > Submitter       : Chris Clayton <chris2553@googlemail.com>
> > Date            : 2009-07-13 8:27 (14 days old)
> > References      : http://marc.info/?l=linux-kernel&m=124747418828398&w=4

Thanks for the update.

Rafael
