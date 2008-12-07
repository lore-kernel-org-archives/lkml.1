Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbYLGUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbYLGUXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYLGUXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:23:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYLGUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:23:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [Bug #12020] scsi_times_out NULL pointer dereference
Date: Sun, 7 Dec 2008 21:22:20 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bernd Schubert <bs@q-leap.de>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.Ia.hpxNJB@chimera> <1228349648.5551.98.camel@localhost.localdomain>
In-Reply-To: <1228349648.5551.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072122.20828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, James Bottomley wrote:
> On Wed, 2008-12-03 at 22:57 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> 
> That's a hard call.  We think this might be fixed by Tejun's block timer
> patch, but the reporter has been unable to reproduce the problem (with
> or without the timer patch).
> 
> Perhaps list as closed for now and reopen if we get another problem
> report with kernels containing the block timer patch?

I closed it as unreproducible on the basis of the last Bugzilla comment.

Thanks,
Rafael
