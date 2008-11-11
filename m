Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYKKHSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYKKHSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYKKHS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:18:27 -0500
Received: from kroah.org ([198.145.64.141]:58556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754698AbYKKHS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:18:26 -0500
Date: Mon, 10 Nov 2008 23:13:01 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, Mike Isely <isely@isely.net>
Subject: Re: [Bug #11829] Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION]
	(USB -&gt; D_STATE)
Message-ID: <20081111071301.GB13596@kroah.com>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera> <4B0Eqx89uNG.A.kYC.vZ1FJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0Eqx89uNG.A.kYC.vZ1FJB@chimera>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 08:43:22PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11829
> Subject		: Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION] (USB -&gt; D_STATE)
> Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> Date		: 2008-10-19 11:26 (22 days old)
> References	: http://marc.info/?l=linux-kernel&m=122441560120027&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> 		  Mike Isely <isely@isely.net>
> Patch		: http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4

This has been fixed already in .27 and in mainline with a patch from
Alan.

thanks,

greg k-h
