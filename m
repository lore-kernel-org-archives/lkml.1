Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbXGQIri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbXGQIri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758655AbXGQIrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:47:01 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:42300 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764555AbXGQIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:46:59 -0400
X-IronPort-AV: i="4.16,545,1175486400"; 
   d="scan'208"; a="45691899:sNHT23268952"
Subject: Re: [PATCH 2/3] Blackfin on-chip watchdog driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Bryan Wu <bryan.wu@analog.com>, LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <michael.frysinger@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070717084814.GA23614@infomag.infomag.iguana.be>
References: <1184439002.3140.24.camel@roc-laptop>
	 <20070717084814.GA23614@infomag.infomag.iguana.be>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 17 Jul 2007 16:53:24 +0800
Message-Id: <1184662404.6503.32.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 17 Jul 2007 08:46:57.0713 (UTC) FILETIME=[08B0E210:01C7C84F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 10:48 +0200, Wim Van Sebroeck wrote:
> Hi Mike, Bryan,
> 
> > This patch implements the driver necessary use the Analog Devices
> > Blackfin processor's on-chip watchdog controller, supports
> > BF53[123]/BF53[467]/BF54[2489]/BF561.
> > 
> > Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > Cc: Wim Van Sebroeck <wim@iguana.be>
> 
> I still need to look at one other driver. After that I will have a look at this one also.
> 
> Greetings,
> Wim.

Thanks a lot. I know, when merge window open, kernel gurus are busy.

Regards,
- Bryan
