Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYKCNcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYKCNcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYKCNcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:32:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbYKCNca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:32:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [Bug #11894] 2.6.28-rc2 / hso driver oops
Date: Mon, 3 Nov 2008 14:37:04 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jonathan McDowell <noodles@earth.li>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.KvF.RkeDJB@chimera> <1225715153.7983.4.camel@achroite>
In-Reply-To: <1225715153.7983.4.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031437.05396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of November 2008, Ben Hutchings wrote:
> On Sun, 2008-11-02 at 17:07 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11894
> > Subject		: 2.6.28-rc2 / hso driver oops
> > Submitter	: Jonathan McDowell <noodles@earth.li>
> > Date		: 2008-10-29 16:40 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122529846811013&w=4
> > Handled-By	: Ben Hutchings <bhutchings@solarflare.com>
> 
> I decoded the oops.  Jonathan has been fixing it himself.

Thanks, updated.

Rafael
