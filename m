Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbXGQIpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbXGQIpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXGQIpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:45:03 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:5867 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330AbXGQIpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:45:00 -0400
Date: Tue, 17 Jul 2007 10:48:14 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Bryan Wu <bryan.wu@analog.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <michael.frysinger@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Blackfin on-chip watchdog driver
Message-ID: <20070717084814.GA23614@infomag.infomag.iguana.be>
References: <1184439002.3140.24.camel@roc-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184439002.3140.24.camel@roc-laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Bryan,

> This patch implements the driver necessary use the Analog Devices
> Blackfin processor's on-chip watchdog controller, supports
> BF53[123]/BF53[467]/BF54[2489]/BF561.
> 
> Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

I still need to look at one other driver. After that I will have a look at this one also.

Greetings,
Wim.
