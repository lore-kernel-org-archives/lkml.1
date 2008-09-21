Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYIURxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYIURxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 13:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYIURx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 13:53:28 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:39412 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYIURx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 13:53:27 -0400
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] acer-wmi: add error checks in module_init
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Content-Disposition: inline
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date: Sun, 21 Sep 2008 18:53:19 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <200809211853.19889.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 21 Sep 2008 17:53:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 September 2008 15:29:59 Akinobu Mita wrote:
> This patch fixes these bugs by using platform_device_register_simple()

[Adding Greg KH to CC - 2nd time lucky...]

Last I heard, platform_device_register_simple() was in the process of being 
deprecated and then slated for future removal. Has this changed?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
