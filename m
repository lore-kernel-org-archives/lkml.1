Return-Path: <linux-kernel-owner+w=401wt.eu-S1161034AbXDCRqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbXDCRqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161010AbXDCRqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:46:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:29008 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161034AbXDCRqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:46:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="207519139:sNHT19144307"
Date: Tue, 3 Apr 2007 10:44:57 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403174457.GA15704@linux-os.sc.intel.com>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46128F47.2010107@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:30:47AM -0700, Ulrich Drepper wrote:
> Reading /proc/cpuinfo or /sys/devices/system/cpu reflects the
> current CPU count.

Not all of the cpu* directories in /sys/devices/system/cpu may be
online.

thanks,
suresh	
