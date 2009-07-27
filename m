Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZG0Wv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZG0Wv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZG0WvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:51:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37159 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZG0WvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:51:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #13844] i915 errors
Date: Tue, 28 Jul 2009 00:51:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Fabio Comolli" <fabio.comolli@gmail.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.wXB._GObKB@chimera> <20090727101143.158ef471@jbarnes-g45>
In-Reply-To: <20090727101143.158ef471@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280051.59655.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Jesse Barnes wrote:
> On Sun, 26 Jul 2009 22:28:30 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13844
> > Subject		: i915 errors
> > Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
> > Date		: 2009-07-25 9:30 (2 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=124851427612720&w=4
> 
> I probably wasn't clear enough in my last mail about this one.  The
> errors have always been present, we just report them now.  I think this
> particular one is harmless, but we should still try to fix it (now that
> we have more data about it).

OK, thanks, I've dropped it from the list of recent regressions, but the bug
is still open.

Best,
Rafael
