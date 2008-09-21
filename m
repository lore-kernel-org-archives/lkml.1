Return-Path: <linux-kernel-owner+w=401wt.eu-S1752482AbYIURxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbYIURxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 13:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYIURwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 13:52:54 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:39408 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYIURwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 13:52:53 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] acer-wmi: add error checks in module_init
Date: Sun, 21 Sep 2008 18:52:46 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, greg@kroah.comgregkh
References: <20080921142958.GC8790@localhost.localdomain>
In-Reply-To: <20080921142958.GC8790@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <200809211852.46998.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 21 Sep 2008 17:52:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 September 2008 15:29:59 Akinobu Mita wrote:
> This patch fixes these bugs by using platform_device_register_simple()

[Adding Greg KH to CC]

Last I heard, platform_device_register_simple() was in the process of being 
deprecated and then slated for future removal. Has this changed?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
