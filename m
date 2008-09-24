Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYIXSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYIXSRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbYIXSRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:17:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbYIXSRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:17:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Bug #11548] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Wed, 24 Sep 2008 20:23:03 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.oAH.j0q1IB@albercik> <1222219121.7160.162.camel@think.oraclecorp.com>
In-Reply-To: <1222219121.7160.162.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809242023.03809.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 24 of September 2008, Chris Mason wrote:
> On Sun, 2008-09-21 at 20:54 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> 
> I'm unable to reproduce this on 2.6.27-rc7.  I don't think it has been
> fixed, but I'm having a hard time finding a reliable way to trigger it
> on newer kernels.

Thanks for the update.

For now, I'll close it as 'unreproducible'.  Please reopen if it happens again.

Thanks,
Rafael
