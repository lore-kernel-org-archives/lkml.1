Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZFIArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZFIArT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZFIArM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:47:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZFIArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:47:12 -0400
Date: Mon, 8 Jun 2009 17:38:39 -0700
From: Greg KH <gregkh@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Gao, Yunpeng" <yunpeng.gao@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Message-ID: <20090609003839.GB22766@suse.de>
References: <20090606164455.GB27257@intel.com> <20090606160413.08c254cf@lxorguk.ukuu.org.uk> <38D9F46DFF92C54980D2F2C1E8EE313001A45F4F3C@pdsmsx503.ccr.corp.intel.com> <1244458030.30939.216.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244458030.30939.216.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 11:47:10AM +0100, David Woodhouse wrote:
> On Mon, 2009-06-08 at 12:23 +0800, Gao, Yunpeng wrote:
> > The Moorestown NAND flash driver is licensed from the Moorestown NAND
> > controller vendor. It's a standalone NAND driver. According to the
> > vendor, this driver has some advanced features specific to the
> > controller hardware and is difficult to port to MTD subsystem. 
> 
> I don't believe it. If the MTD subsystem doesn't support certain
> features, the MTD subsystem needs to be updated to cope.

Based on this response, I am guessing that you do not want me to take
this in the staging tree? :)

If so, please let me know and I'll drop it.

thanks,

greg k-h
