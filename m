Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZHKMkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZHKMkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHKMkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:40:08 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:63758 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbZHKMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:40:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABYDgUpR92pY/2dsb2JhbADRfwmEEAWCJw
Date: Tue, 11 Aug 2009 14:40:07 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 5/5] [WATCHDOG] Add support for WM831x watchdog
Message-ID: <20090811124007.GE4302@infomag.iguana.be>
References: <1249922635-31864-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1249922635-31864-5-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249922635-31864-5-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> The WM831x series of devices provide a watchdog with configurable
> behaviour on timer expiry.
> 
> Currently this driver support refreshes via a register or GPIO line and
> autonomous refreshes from a hardware source (eg, a clock).
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

Will review this the coming week.

Kind regards,
Wim.

