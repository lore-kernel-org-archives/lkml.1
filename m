Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbXG0Bma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbXG0Bma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759566AbXG0BmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:42:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735AbXG0BmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:42:20 -0400
Date: Thu, 26 Jul 2007 18:41:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai.Lu@Sun.COM
Cc: Horms <horms@verge.net.au>, linux-ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Andi Kleen <ak@suse.de>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Russell King <rmk@arm.linux.org.uk>, Gerd Hoffmann <kraxel@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: Regression in serial console on ia64 after 2.6.22
Message-Id: <20070726184130.404a13d3.akpm@linux-foundation.org>
In-Reply-To: <46A76E95.90903@sun.com>
References: <20070719074147.GA23879@verge.net.au>
	<46A0191E.3000100@sun.com>
	<200707241657.33095.yinghai.lu@sun.com>
	<20070725071718.GB18068@verge.net.au>
	<46A76E95.90903@sun.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 08:39:01 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> >> Subject         : Regression in serial console on ia64 after 2.6.22
> >> References      : http://marc.info/?l=linux-ia64&m=118483645914066&w=2
> >> Last known good : ?
> >> Submitter       : Horms <horms@verge.net.au>
> >> Caused-By       : Yinghai Lu <Yinghai.Lu@Sun.COM>
> >>                   commit 18a8bd949d6adb311ea816125ff65050df1f3f6e

afaik we still haven't fixed this and I don't think we've seen
the final agreed-upon patch?

Thanks.
