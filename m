Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZG0JHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZG0JHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbZG0JHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:07:18 -0400
Received: from cmpxchg.org ([85.214.51.133]:42311 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbZG0JHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:07:17 -0400
Date: Mon, 27 Jul 2009 11:05:14 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #13649] Bad page state in process with various applications
Message-ID: <20090727090514.GA5618@cmpxchg.org>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.aOG.BXObKB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <H5-1lZIIeYK.A.aOG.BXObKB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 10:45:33PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13649
> Subject		: Bad page state in process with various applications
> Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
> Date		: 2009-06-20 15:27 (37 days old)
> References	: http://marc.info/?l=linux-mm&m=124551168828090&w=4
> Handled-By	: Mel Gorman <mel@csn.ul.ie>
> Patch		: http://patchwork.kernel.org/patch/33130/

Fixed in mainline: c277331d5fbaae5772ed19862feefa91f4e477d3
