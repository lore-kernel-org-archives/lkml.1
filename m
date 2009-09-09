Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZIIPWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZIIPWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZIIPWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:22:03 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40184 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZIIPWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:22:01 -0400
Date: Wed, 9 Sep 2009 16:22:06 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #14141] order 2 page allocation failures
Message-ID: <20090909152206.GJ24614@csn.ul.ie>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.RWB.7eBpKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Vm51Upp4EV.A.RWB.7eBpKB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 07:24:58PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
> Subject		: order 2 page allocation failures
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2009-09-06 7:40 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
> Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>
> 

AFAIK, this is still a problem. Have requested more information in
relation to the bug. 

As an aside, the subject seems to have lost the iwlagn aspect of this
bug.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
