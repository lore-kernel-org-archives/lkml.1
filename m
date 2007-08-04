Return-Path: <linux-kernel-owner+w=401wt.eu-S1764831AbXHDNY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764831AbXHDNY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbXHDNYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:24:22 -0400
Received: from cm135.gamma145.maxonline.com.sg ([202.156.145.135]:57992 "EHLO
	kerndev.sin.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757966AbXHDNYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:24:21 -0400
Date: Sat, 4 Aug 2007 21:24:13 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>, Antonino Daplas <adaplas@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/video/geode/lxfb_core.c: cleanups
Message-ID: <20070804132413.GA25347@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20070804130242.GD3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804130242.GD3972@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<quote sender="Adrian Bunk">
> This pacth contains the following cleanups:
> - make the needlessly global geode_modedb[] static
> - lxfb_setup(): remove an unused variable

I have submitted a patch for the 2nd cleanup:
http://marc.info/?l=linux-mm-commits&m=118616305111463&w=2

Thanks,
Eugene
