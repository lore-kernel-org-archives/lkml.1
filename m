Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbZHBNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbZHBNpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZHBNpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:45:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:22756 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZHBNpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=qxIzFzKBA3N/ZGDYNe6PZOVc1jmpPR43wqmVsbNiKXJ2rs9HI3kR0w3YZWnoJBdaFb
         3neJNJzZPv2srx1HgIsyGI0RH9ZQRl+KfXqxti0ZrbdeVQ2YORnMDDNsqJ18MNW0igms
         xLmLyb44/V1v7ogv3ONgSg/vkm3LXnZxUWyzU=
Date: Sun, 2 Aug 2009 15:45:46 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
Message-ID: <20090802154546.55418e52@varda>
In-Reply-To: <H5-1lZIIeYK.A.cJ.jYObKB@chimera>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	<H5-1lZIIeYK.A.cJ.jYObKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 26 Jul 2009 22:45:27 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> escribió:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).

 Sorry for the delay i did not have the time to test 2.6.31-rc* until now.
Tried 2.6.31-rc5 the problem persist. The revert still fixes the issue; so
the bug should be still present.

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
> Subject		: rt2x00: slow wifi with correct basic rate bitmap
> Submitter	: Alejandro Riveira <ariveira@gmail.com>
> Date		: 2009-05-22 13:32 (66 days old)
> 
> 

Thanks;
Alejandro
