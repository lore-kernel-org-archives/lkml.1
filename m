Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZKVTGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZKVTGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 14:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZKVTGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 14:06:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42473 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZKVTGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 14:06:30 -0500
Date: Sun, 22 Nov 2009 21:06:25 +0200
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Staging: IIO: Add tsl2560-2 support to tsl2563
 driver.
Message-ID: <20091122190625.GG16444@smtp.gmail.com>
Mail-Followup-To: Jonathan Cameron <jic23@cam.ac.uk>,
	Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <4B06EA3B.10500@cam.ac.uk>
 <20091120191739.GA16233@suse.de>
 <4B096002.6060702@cam.ac.uk>
 <4B0960CD.7020302@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B0960CD.7020302@cam.ac.uk>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Nov 22, Jonathan Cameron wrote:
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
> Minimal changes to driver. Just adds the device to the id
> table and adjusts the Kconfig elements appropriately.
> 
> Adding further similar chips from TAOS is complicated by their
> different conversion functions (and hence left for now).
> 
>  drivers/staging/iio/light/Kconfig   |    6 +++---
>  drivers/staging/iio/light/tsl2563.c |   11 ++++++-----
>  2 files changed, 9 insertions(+), 8 deletions(-)


Acked-by: Amit Kucheria <amit.kucheria@verdurent.com>

-- 
------------------------------------------------------------
Amit Kucheria, Finland
------------------------------------------------------------
