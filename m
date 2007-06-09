Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbXFIQPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbXFIQPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXFIQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:14:58 -0400
Received: from panic.printk.net ([217.147.83.20]:58143 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbXFIQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:14:57 -0400
Subject: Re: Size of kernel modules
From: Jon Masters <jonathan@jonmasters.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Kyle McMartin <kyle@canonical.com>,
       Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706091558460.14652@fbirervta.pbzchgretzou.qr>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
	 <20070608034421.GM26717@fattire.cabal.ca>
	 <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
	 <Pine.LNX.4.64.0706090954310.4353@fbirervta.pbzchgretzou.qr>
	 <1181390911.3306.22.camel@jcmlaptop>
	 <Pine.LNX.4.64.0706091558460.14652@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 09 Jun 2007 12:14:06 -0400
Message-Id: <1181405646.3306.27.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 15:59 +0200, Jan Engelhardt wrote:
> On Jun 9 2007 08:08, Jon Masters wrote:
> >
> >So I missed half of this conversation - you're saying that on a
> >CONFIG_DEBUG_KERNEL, you have such large .ko module files that depmod
> >segfaults? Can I get a core dump or any further information? :-)
> 
> Just make sure your /lib/modules/<kernel> is like 300 megabytes or even
> more. Then depmod will clog up quite a lot memory already. (Taking a 256 mb ram
> machine for example, no swap or just very little.)

I'll go take a look at that.

Jon.


