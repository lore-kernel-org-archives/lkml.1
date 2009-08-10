Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbZHJOFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbZHJOFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZHJOFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:05:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbZHJOFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:05:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: chris2553@googlemail.com
Subject: Re: [Bug #13846] LEDs switched off permanently by power saving with rt61pci driver
Date: Mon, 10 Aug 2009 16:06:27 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.EjD.3j1fKB@chimera> <200908101111.16762.chris2553@googlemail.com>
In-Reply-To: <200908101111.16762.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101606.27144.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Chris Clayton wrote:
> Hi Rafael,
> 
> On Sunday 09 August 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> 
> Ivo sent a test patch for this and I tested it., but without success. I reported my findings but 
> didn't get a reply. See http://marc.info/?l=linux-wireless&m=124940189007154&w=4.
> 
> I suspect the failure is due to the same PS hardware probelms that were at the route of my original 
> report.. Unless one of the wireless folks say otherwise, I think we should close this on the basis 
> of busted hardware. I'm happy to simply eject the card and re-insert it now that I have some udev 
> scripts to tear down the wireless configuration on the ejection and set it uop again when the card 
> is re-inserted.

Thanks, closed.

Rafael
