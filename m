Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXIGBeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXIGBeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 21:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXIGBe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 21:34:29 -0400
Received: from mxsf00.insightbb.com ([74.128.0.70]:50830 "EHLO
	mxsf00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbXIGBe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 21:34:28 -0400
X-IronPort-AV: E=Sophos;i="4.20,218,1186372800"; 
   d="scan'208";a="24881604"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALJG4EZKjlCP/2dsb2JhbACBWg
X-IronPort-AV: E=Sophos;i="4.20,218,1186372800"; 
   d="scan'208";a="76017819"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Vladimir Shebordaev <vladimir.shebordaev@gmail.com>
Subject: Re: [PATCH] [input] USB touchscreen
Date: Thu, 6 Sep 2007 21:34:25 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, Vladimir Shebordaev <vshebordaev@mail.ru>
References: <1189114167987-git-send-email-vshebordaev@mail.ru>
In-Reply-To: <1189114167987-git-send-email-vshebordaev@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709062134.25804.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2007 17:29, Vladimir Shebordaev wrote:
> This patch fixes a nasty typo in usbtouchscreen driver.
> 
> The typo is inherited from the original mtouchusb. It
> used to make the input subsytem to incorrectly
> report the physical device ids to userspace that in turn
> is much confusing for, e.g. XInput hotplug facilities in
> setups with multiple identical touchscreens.
> 
> Signed-off-by: Vladimir Shebordaev <vshebordaev@mail.ru>

Applied, thank you Vladimir.

-- 
Dmitry
