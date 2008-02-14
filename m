Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYBNVtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYBNVtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbYBNVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:49:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:41633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbYBNVtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:49:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,354,1199692800"; 
   d="scan'208";a="257974597"
Date: Thu, 14 Feb 2008 13:48:07 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Jike Song <albcamus@gmail.com>,
       Rijndael Cosque <rijcos@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: What's the status of x2APIC support in Linux kernel?
Message-ID: <20080214214807.GA27194@linux-os.sc.intel.com>
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com> <p73fxwc50s5.fsf@bingen.suse.de> <20080201180822.GA376@linux-os.sc.intel.com> <200802141206.37542.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802141206.37542.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:06:37PM -0700, Bjorn Helgaas wrote:
> 
> Are you adding x2apic support for both x86 and ia64, or only for x86?

x2apic extension is specific to x86. ia64 already has an advanced lsapic,
isn't it..

thanks,
suresh
