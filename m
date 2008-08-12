Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYHLOst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYHLOst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYHLOsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:48:40 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:44384 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYHLOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:48:40 -0400
Date: Tue, 12 Aug 2008 15:48:41 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [Bug #11275] [BUG] hugetlb: sleeping function called from
	invalid context
Message-ID: <20080812144841.GA16724@brain>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.Fm.6CjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.Fm.6CjnIB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11275
> Subject		: [BUG] hugetlb: sleeping function called from invalid context
> Submitter	: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Date		: 2008-08-06 14:43 (4 days old)
> References	: http://marc.info/?l=linux-mm&m=121803401427843&w=4
> Handled-By	: Andy Whitcroft <apw@shadowen.org>
> Patch		: http://marc.info/?l=linux-kernel&m=121804949526359&w=4

This patch was superceeded by a newer version:
	http://marc.info/?l=linux-kernel&m=121819389913563&w=2

Currently this is in -mm, awaiting merge.

-apw
