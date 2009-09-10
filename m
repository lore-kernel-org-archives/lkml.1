Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZIJVOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZIJVOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZIJVOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:14:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40649 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbZIJVOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:14:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures
Date: Thu, 10 Sep 2009 23:14:59 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Pekka Enberg <penberg@cs.helsinki.fi>,
       reinette chatre <reinette.chatre@intel.com>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.RWB.7eBpKB@chimera> <20090909152206.GJ24614@csn.ul.ie>
In-Reply-To: <20090909152206.GJ24614@csn.ul.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102315.00052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009, Mel Gorman wrote:
> On Sun, Sep 06, 2009 at 07:24:58PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
> > Subject		: order 2 page allocation failures
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2009-09-06 7:40 (1 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
> > Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> 
> AFAIK, this is still a problem. Have requested more information in
> relation to the bug. 
> 
> As an aside, the subject seems to have lost the iwlagn aspect of this
> bug.

Fixed.  I also moved the bug to "drivers/network-wireless" as it seems to
be specific to iwlagn.

Thanks,
Rafael
