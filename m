Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbYIUTBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbYIUTBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYIUTBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:01:04 -0400
Received: from v813.rev.tld.pl ([195.149.226.213]:55397 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYIUTBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:01:02 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2008 15:01:01 EDT
X-clamdmail: clamdmail 0.18a
From: Marcin Juszkiewicz <marcin@haerwu.biz>
To: Akinobu Mita <akinobu.mita@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] progear_bl: use platform_device_register_simple()
Date: Sun, 21 Sep 2008 20:54:17 +0200
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc6; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20080921143827.GF8790@localhost.localdomain>
In-Reply-To: <20080921143827.GF8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809212054.18346.marcin@haerwu.biz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 of September 2008 16:38:29 Akinobu Mita wrote:
> This change also fixes error handling when platform_device_alloc()
> fails. (When platform_device_alloc() failed, it returns error without
> unregistering progearbl_driver)

I do not have this hardware working now so will not be able to test it 
during next month or two.

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Marcin Juszkiewicz <linux@hrw.one.pl>
> Cc: Richard Purdie <rpurdie@rpsys.net>



