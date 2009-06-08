Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZFHKrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZFHKrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZFHKrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:47:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:58540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbZFHKrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:47:14 -0400
Subject: RE: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
From: David Woodhouse <dwmw2@infradead.org>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <38D9F46DFF92C54980D2F2C1E8EE313001A45F4F3C@pdsmsx503.ccr.corp.intel.com>
References: <20090606164455.GB27257@intel.com>
	 <20090606160413.08c254cf@lxorguk.ukuu.org.uk>
	 <38D9F46DFF92C54980D2F2C1E8EE313001A45F4F3C@pdsmsx503.ccr.corp.intel.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 11:47:10 +0100
Message-Id: <1244458030.30939.216.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 12:23 +0800, Gao, Yunpeng wrote:
> The Moorestown NAND flash driver is licensed from the Moorestown NAND
> controller vendor. It's a standalone NAND driver. According to the
> vendor, this driver has some advanced features specific to the
> controller hardware and is difficult to port to MTD subsystem. 

I don't believe it. If the MTD subsystem doesn't support certain
features, the MTD subsystem needs to be updated to cope.

When can I have test hardware?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

