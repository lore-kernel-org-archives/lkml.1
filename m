Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbXCCWuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbXCCWuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXCCWuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:50:05 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:59811 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030525AbXCCWuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:50:04 -0500
Date: Sat, 3 Mar 2007 23:50:02 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Message-ID: <20070303225002.GB28961@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Arnd Bergmann <arnd@arndb.de>, bryan.wu@analog.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <200703032330.50116.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703032330.50116.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 11:30:49PM +0100, Arnd Bergmann wrote:

> It might be nicer to make this
> 
> 	for (;;)
> 		asm volatile ("idle");

This looks remarkably like relax_cpu()

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
