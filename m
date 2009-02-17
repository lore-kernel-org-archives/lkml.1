Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZBQKvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZBQKvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZBQKvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:51:10 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58000 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZBQKvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:51:09 -0500
Date: Tue, 17 Feb 2009 11:51:04 +0100
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mattia Dongili <malattia@linux.it>
Subject: Re: [Bug #12494] Sony backlight regression from 2.6.28 to 29-rc
Message-ID: <20090217105104.GA27043@gamma.logic.tuwien.ac.at>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.KYG.-s0lJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rjPbZ5GRJPO.A.KYG.-s0lJB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 14 Feb 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12494
> Subject		: Sony backlight regression from 2.6.28 to 29-rc
> Submitter	: Norbert Preining <preining@logic.at>
> Date		: 2009-01-19 8:14 (27 days old)
> References	: http://marc.info/?l=linux-acpi&m=123235286829512&w=4
> Handled-By	: Mattia Dongili <malattia@linux.it>

2.6.29-rc5 activates config_fb automatically, so that should be fixed.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
The suit into which the man's body had been stuffed looked
as if it's only purpose in life was to demonstrate how
difficult it was to get this sort of body into a suit.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
