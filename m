Return-Path: <linux-kernel-owner+w=401wt.eu-S1764177AbXHIXRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764177AbXHIXRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXHIXQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:16:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:17623 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbXHIXQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:16:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,243,1183359600"; 
   d="scan'208";a="276883118"
Date: Thu, 9 Aug 2007 16:13:58 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, akpm@linux-foundation.org
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-Id: <20070809161358.4a6091fc.kristen.c.accardi@intel.com>
In-Reply-To: <20070809230436.GA18938@stusta.de>
References: <20070723145105.GK26212@stusta.de>
	<20070809145140.654303a0.kristen.c.accardi@intel.com>
	<20070809222427.GA32127@suse.de>
	<20070809154702.caa67a61.kristen.c.accardi@intel.com>
	<20070809230436.GA18938@stusta.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 01:04:36 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> We have tons of unmaintained drivers and none of them has such a silly 
> auto-NAK policy.
> 
> cu
> Adrian

Silly is in the eye of the beholder.  I don't want to take this patch
because it needs to be reviewed by someone who really knows the intent
of the driver.  Seems silly to me to blindly take patches.
