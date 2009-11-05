Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZKETCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZKETCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbZKETCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:02:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:27221 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbZKETCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fOXejzRXPn/O8GRfxdsV+gaGV1PMIrNJBpnM55IiR4CNq2pUY1siH4tqOonSlxisJc
         QkKKZGWRZC5TjCXDpUSuTeP0zUO7sA6fB1wVzrSac6Gxm9pX6f8Op+HP3Xn9k5+mteTi
         bqXuS0Vl8wMuv/h3Ey4iJ9iqE3J5MdTZU2xzU=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 31/41] rt2800usb: add RXINFO_DESC_SIZE definition
Date: Thu, 5 Nov 2009 20:02:47 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173547.28463.36376.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173547.28463.36376.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911052002.48198.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add RXINFO_DESC_SIZE definition
> 
> Add RXINFO_DESC_SIZE definition and use it instead of abusing
> RXD_DESC_SIZE one (TXD_DESC_SIZE and RXD_DESC_SIZE are specific
> to PCI version of the chipset).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
