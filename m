Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZKVTFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZKVTFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 14:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZKVTFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 14:05:05 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36581 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZKVTFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 14:05:04 -0500
Date: Sun, 22 Nov 2009 21:04:58 +0200
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Staging: IIO: Remove tsl2561 driver. Support
 merged with tsl2563.
Message-ID: <20091122190458.GF16444@smtp.gmail.com>
Mail-Followup-To: Jonathan Cameron <jic23@cam.ac.uk>,
	Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <4B06EA3B.10500@cam.ac.uk>
 <20091120191739.GA16233@suse.de>
 <4B096002.6060702@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B096002.6060702@cam.ac.uk>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Nov 22, Jonathan Cameron wrote:
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> ---
> This patch simply removes the tsl2561 driver.
> 
>  drivers/staging/iio/light/Kconfig   |    9 --
>  drivers/staging/iio/light/Makefile  |    1 -
>  drivers/staging/iio/light/tsl2561.c |  272 -----------------------------------
>  3 files changed, 0 insertions(+), 282 deletions(-)
> 

Acked-by: Amit Kucheria <amit.kucheria@verdurent.com>

-- 
------------------------------------------------------------
Amit Kucheria, Finland
------------------------------------------------------------
