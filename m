Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZGHA4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZGHA4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZGHAz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:55:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:4924 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbZGHAz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:55:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,365,1243839600"; 
   d="scan'208";a="162557152"
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets
	displayed when it should not be
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200907072211.08609.rjw@sisk.pl>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	 <bXZeuxPQAWE.A.BN.NBpUKB@chimera> <200907072119.59171.elendil@planet.nl>
	 <200907072211.08609.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 08:56:31 +0800
Message-Id: <1247014591.15520.171.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 04:11 +0800, Rafael J. Wysocki wrote:
> On Tuesday 07 July 2009, Frans Pop wrote:
> > On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > > be listed and let me know (either way).
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> > > Subject	: Warning 'Invalid throttling state, reset' gets displayed when
> > >		  it should not be 
> > > Submitter	: Frans Pop <elendil@planet.nl> 
> > > Date		: 2009-05-26 15:24 (42 days old)
> > > Handled-By	: Frans Pop <elendil@planet.nl>
> > > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
> > > 		  http://bugzilla.kernel.org/attachment.cgi?id=21672
> > 
both
Acked-by: Zhang Rui <rui.zhang@intel.com>

thanks,
rui

> > I still have not received any reaction from the ACPI maintainers to the 
> > bug or the proposed patches.
> 
> Sorry for that.
> 
> Len, what do you think of the patches listed above?
> 
> Rafael

