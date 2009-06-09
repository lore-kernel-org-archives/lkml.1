Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZFIDOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZFIDOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZFIDOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:14:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:14162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZFIDON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:14:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,328,1241420400"; 
   d="scan'208";a="152086051"
Date: Tue, 9 Jun 2009 18:48:53 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Message-ID: <20090609104853.GA3046@intel.com>
References: <20090606164455.GB27257@intel.com> <20090606160413.08c254cf@lxorguk.ukuu.org.uk> <38D9F46DFF92C54980D2F2C1E8EE313001A45F4F3C@pdsmsx503.ccr.corp.intel.com> <1244458030.30939.216.camel@macbook.infradead.org> <20090609003839.GB22766@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609003839.GB22766@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 08:38:39AM +0800, Greg KH wrote:
> On Mon, Jun 08, 2009 at 11:47:10AM +0100, David Woodhouse wrote:
> > On Mon, 2009-06-08 at 12:23 +0800, Gao, Yunpeng wrote:
> > > The Moorestown NAND flash driver is licensed from the Moorestown NAND
> > > controller vendor. It's a standalone NAND driver. According to the
> > > vendor, this driver has some advanced features specific to the
> > > controller hardware and is difficult to port to MTD subsystem. 
> > 
> > I don't believe it. If the MTD subsystem doesn't support certain
> > features, the MTD subsystem needs to be updated to cope.
> 
> Based on this response, I am guessing that you do not want me to take
> this in the staging tree? :)
> 
> If so, please let me know and I'll drop it.
> 
> thanks,
> 
> greg k-h

Hi Greg,

   Thanks for the reminder. But I need to discuss with David first to get more
   info from him and then decide to submit to MTD or not. Before that, please
   hold this patch in staging tree and don't drop it. Thank you.

   Rgds,
   Yunpeng

