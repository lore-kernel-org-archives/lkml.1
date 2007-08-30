Return-Path: <linux-kernel-owner+w=401wt.eu-S1764194AbXHaCFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764194AbXHaCFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 22:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759309AbXHaCFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 22:05:06 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:58007 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762377AbXHaCFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 22:05:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALMT10ZKhRO4/2dsb2JhbACBVg
X-IronPort-AV: E=Sophos;i="4.19,328,1183348800"; 
   d="scan'208";a="120121116"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make the dummy touchkit_ps2_detect() static
Date: Thu, 30 Aug 2007 01:11:39 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070814212252.GF18945@stusta.de>
In-Reply-To: <20070814212252.GF18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708300111.39956.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Tuesday 14 August 2007 17:22, Adrian Bunk wrote:
> The dummy touchkit_ps2_detect() for the CONFIG_MOUSE_PS2_TOUCHKIT=n case 
> shouldn't be a global function.
> 

Applied, thank you.

Btw, sorry for the long silence - I had a hard drive crash and the day
after I restored everything the disk controller decided to die as well
and write garbage all over the new disk ;(

-- 
Dmitry
