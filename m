Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbYCDTqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbYCDTqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYCDTpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:45:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:37583 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYCDTpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:45:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,444,1199692800"; 
   d="scan'208";a="214809872"
Date: Tue, 4 Mar 2008 11:37:28 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: pcihpd-discuss@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Pcihpd-discuss] 2.6.25-rc3 -- SHPC hotplug driver - very long
 timeouts?
Message-ID: <20080304113728.47bc5019@appleyard>
In-Reply-To: <a44ae5cd0802252030m77bb2b9p7de615a9f863b81d@mail.gmail.com>
References: <a44ae5cd0802252030m77bb2b9p7de615a9f863b81d@mail.gmail.com>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 23:30:03 -0500
"Miles Lane" <miles.lane@gmail.com> wrote:

> Hello,
> 
> When I booted this kernel, the process was hugely delayed in shpchp.
> I don't think I usually build this driver, so perhaps this is its
> standard behavior when the hardware is missing, or some such?  Or, is
> this a bug in the driver?  Either way, the timeouts seem excessively
> long.
 

Hi,
I was just getting caught up on mail and saw this - did this get
resolved or is this still an open issue?

Thanks,
Kristen
