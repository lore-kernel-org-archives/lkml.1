Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYKFPrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYKFPrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYKFPra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:47:30 -0500
Received: from kroah.org ([198.145.64.141]:55574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751392AbYKFPr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:47:28 -0500
Date: Thu, 6 Nov 2008 07:43:51 -0800
From: Greg KH <greg@kroah.com>
To: H L <swdevyid@yahoo.com>
Cc: Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081106154351.GA30459@kroah.com>
References: <20081106044828.GA30417@kroah.com> <909674.99469.qm@web45112.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <909674.99469.qm@web45112.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 07:40:12AM -0800, H L wrote:
> 
> Greetings (from a new lurker to the list),

Welcome!

> To your question Greg, "yes" and "sort of" ;-).  I have started taking
> a look at these patches with a strong interest in understanding how
> they work.  I've built a kernel with them and tried out a few things
> with real SR-IOV hardware.

Did you have to modify individual drivers to take advantage of this
code?  It looks like the core code will run on this type of hardware,
but there seems to be no real advantage until a driver is modified to
use it, right?

Or am I missing some great advantage to having this code without
modified drivers?

thanks,

greg k-h
