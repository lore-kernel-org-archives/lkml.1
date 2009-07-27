Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZG0WGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZG0WGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZG0WGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:06:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbZG0WGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:06:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [Bug #13649] Bad page state in process with various applications
Date: Tue, 28 Jul 2009 00:06:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Mel Gorman <mel@csn.ul.ie>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.aOG.BXObKB@chimera> <20090727090514.GA5618@cmpxchg.org>
In-Reply-To: <20090727090514.GA5618@cmpxchg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280006.50647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Johannes Weiner wrote:
> On Sun, Jul 26, 2009 at 10:45:33PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13649
> > Subject		: Bad page state in process with various applications
> > Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date		: 2009-06-20 15:27 (37 days old)
> > References	: http://marc.info/?l=linux-mm&m=124551168828090&w=4
> > Handled-By	: Mel Gorman <mel@csn.ul.ie>
> > Patch		: http://patchwork.kernel.org/patch/33130/
> 
> Fixed in mainline: c277331d5fbaae5772ed19862feefa91f4e477d3

Thanks, closed.

Rafael
