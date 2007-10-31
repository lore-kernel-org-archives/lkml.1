Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXJaESY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXJaESY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXJaESQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:18:16 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:19286 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXJaESP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:18:15 -0400
X-IronPort-AV: i="4.21,349,1188792000"; 
   d="scan'208"; a="42755640:sNHT31821202"
Subject: Re: [PATCH 07/14] Blackfin SPI driver: Add SPI master controller
	platform device 1
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: Bryan Wu <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
In-Reply-To: <200710301208.13367.david-b@pacbell.net>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <1193735885-8202-8-git-send-email-bryan.wu@analog.com>
	 <200710301208.13367.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 31 Oct 2007 12:18:05 +0800
Message-Id: <1193804285.6971.9.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 31 Oct 2007 04:18:14.0106 (UTC) FILETIME=[0E0F33A0:01C81B75]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-30 at 12:08 -0700, David Brownell wrote:
> On Tuesday 30 October 2007, Bryan Wu wrote:
> > From: Sonic Zhang <sonic.zhang@analog.com>
> > 
> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> 
> The patch comments in this series leave a bit to be desired,
> especially patches from Sonic.  (Several are like this one:
> just a $SUBJECT, no description.)  I've improved them in the
> versions I'll be sending on ...
> 
Sorry, that's my fault. 

Sonic's original patch modified this driver file and the Blackfin arch
related files. So I separated the patch to this SPI driver specific code
and Blackfin arch related patch which should be merged in Blackfin git
tree.

But I didn't change the description and subject here.

> It's worth noting that in this case the $SUBJECT doesn't
> relate *at all* to what this patch actually does!  Namely,
> it uses the portmux mechanism to add support for two more
> SPI buses ... it doesn't add a platform device.
> 

Sorry again, it will not happen again.

-Bryan Wu
