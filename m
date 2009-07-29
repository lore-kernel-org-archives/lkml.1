Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbZG2Nff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbZG2Nff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZG2Nfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:35:34 -0400
Received: from kroah.org ([198.145.64.141]:38976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbZG2Nfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:35:33 -0400
Date: Wed, 29 Jul 2009 06:29:12 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Kaltsas <alexkaltsas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #13681] A number of usb Devices causes Oops messages and
 kernel panics.
Message-ID: <20090729132912.GA28227@kroah.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
 <H5-1lZIIeYK.A.88F.6WObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <H5-1lZIIeYK.A.88F.6WObKB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 10:45:34PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13681
> Subject		: A number of usb Devices causes Oops messages and kernel panics.
> Submitter	: Alexander Kaltsas <alexkaltsas@gmail.com>
> Date		: 2009-06-30 13:06 (27 days old)

This can no longer be reproduced by the original reporter, so it should
be closed.

thanks,

greg k-h
