Return-Path: <linux-kernel-owner+w=401wt.eu-S1422648AbXBUSrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422648AbXBUSrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422775AbXBUSrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:47:13 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:43566 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648AbXBUSrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:47:12 -0500
Date: Wed, 21 Feb 2007 18:47:07 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2.6.21-rc1] serial: serial_txx9 driver update (take 2)
Message-ID: <20070221184707.GA8957@linux-mips.org>
References: <20070222.021728.92343740.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222.021728.92343740.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 02:17:28AM +0900, Atsushi Nemoto wrote:

> Update the serial_txx9 driver.
> 
>  * Use platform_device.
>  * Fix and cleanup suspend/resume/initialization codes.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Acked-by: Alan Cox <alan@redhat.com>

Andrew, I've applied this patch on linux-mips.org and if nobody else
raises any issues I'll take care of merging this.

  Ralf
