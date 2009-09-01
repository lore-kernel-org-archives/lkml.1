Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZIAGt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZIAGt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 02:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZIAGtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 02:49:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:34944 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbZIAGty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 02:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,311,1249282800"; 
   d="scan'208";a="444468756"
Subject: Re: [PATCH V5 0/2] Ambient Light Sensor support
From: Zhang Rui <rui.zhang@intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20090901070129.F402D526EA5@mailhub.coreip.homeip.net>
References: <1251706025.3483.159.camel@rzhang-dt>
	 <alpine.LFD.2.00.0908311303340.19451@localhost.localdomain>
	 <20090901070129.F402D526EA5@mailhub.coreip.homeip.net>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 14:47:47 +0800
Message-Id: <1251787667.3483.197.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 14:28 +0800, Dmitry Torokhov wrote:
> On Mon, Aug 31, 2009 at 01:04:35PM -0400, Len Brown wrote:
> > I put this in the acpi test tree, with the expectation
> > that it will have at least one minor revision update
> > before going upstream.
> > 
> > thanks,
> > Len Brown, Intel Open Source Technology Center
> > 
> 
> Breaks build here...
> 
that's weird.
I didn't encounter this problem in my test.

could you please send your kernel config file?

thanks,
rui

