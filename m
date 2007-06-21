Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbXFUM2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbXFUM2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 08:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXFUM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 08:28:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbXFUM2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 08:28:30 -0400
Date: Thu, 21 Jun 2007 05:28:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: long-term regression
Message-Id: <20070621052807.cc64605d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706171052240.28371@asgard.lang.hm>
References: <Pine.LNX.4.64.0706171052240.28371@asgard.lang.hm>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 17 Jun 2007 10:57:55 -0700 (PDT) david@lang.hm wrote:
> I haven't had time to bisect this, but I'm having a problem on a AMD64 
> gentoo system where the printer doesn't work with recent kernels.
> 
> 2.6.18-rc3 worked
> 2.6.21.1 doesn't
> 2.6.22-rc4 doesn't
> 
> unfortunantly the system is gooted on 2.6.18 at the moment and I'm out of 
> town so my ability to test is limited I can provide the 2.6.22-rc4 
> (attached) and 2.6.18-rc3 configs.
> 
> dmesg appears to show the port being detected, but writes to the port 
> under newer kernels appear to complete, but no data gets to the printer.
> 
> any suggestions other then doing the large bisect?

That would be good, thanks.  Please be sure to cc linux-usb-devel on 
the results.
