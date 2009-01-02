Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZABWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZABWXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbZABWX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:23:27 -0500
Received: from mga10.intel.com ([192.55.52.92]:57957 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756919AbZABWX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:23:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,319,1228118400"; 
   d="scan'208";a="654189789"
Message-ID: <495E93D4.3060401@linux.intel.com>
Date: Fri, 02 Jan 2009 14:23:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27/2.6.28: irqbalance dies shortly after starting the daemon
 on x86 but not x86_64, why?
References: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> (same on both x86 and x86_64):
> # cat /etc/default/irqbalance
> #Configuration for the irqbalance daemon
> 
> #Should irqbalance be enabled?
> ENABLED=1
> #Balance the IRQs only once?
> ONESHOT="0"


which version of irqbalance is this?
