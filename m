Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbZBDQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbZBDQyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZBDQyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:54:12 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57128 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZBDQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:54:12 -0500
Date: Wed, 4 Feb 2009 08:54:10 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [Bug #12615] boot hangs while bringing up gianfar ethernet
Message-ID: <20090204165410.GA21717@ovro.caltech.edu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.2aD.muYiJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pWZw1SZjMCH.A.2aD.muYiJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 04 Feb 2009 08:54:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 11:24:08AM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12615
> Subject		: boot hangs while bringing up gianfar ethernet
> Submitter	: Ira Snyder <iws@ovro.caltech.edu>
> Date		: 2009-01-29 19:41 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=123325817201665&w=4
> 
> 

Tested this morning with Linux version 2.6.29-rc3-00563-g37f752c, and I
still see the same behavior.

Thanks,
Ira
