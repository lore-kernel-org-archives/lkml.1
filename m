Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZEaFUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZEaFUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 01:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZEaFUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 01:20:23 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35886 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZEaFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 01:20:22 -0400
Subject: Re: [PATCH 1/3] isdn: rename capi_ctr_reseted() to capi_ctr_down()
From: Marcel Holtmann <marcel@holtmann.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: davem@davemloft.net, Karsten Keil <karsten-keil@t-online.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090531-patch-01.tilman@imap.cc>
References: <20090531-patch-00.tilman@imap.cc>
	 <20090531-patch-01.tilman@imap.cc>
Content-Type: text/plain
Date: Sun, 31 May 2009 07:19:41 +0200
Message-Id: <1243747181.3523.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tilman,

> Change the name of the Kernel CAPI exported function capi_ctr_reseted()
> to something representing its purpose better.
> 
> Impact: function renamed, no functional change
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> ---
>  Documentation/isdn/INTERFACE.CAPI |    4 ++--
>  drivers/isdn/capi/kcapi.c         |    8 ++++----
>  drivers/isdn/hardware/avm/b1.c    |    2 +-
>  drivers/isdn/hardware/avm/b1dma.c |    2 +-
>  drivers/isdn/hardware/avm/c4.c    |    4 ++--
>  drivers/isdn/hardware/avm/t1isa.c |    2 +-
>  drivers/isdn/hysdn/hycapi.c       |    4 ++--
>  include/linux/isdn/capilli.h      |    2 +-
>  net/bluetooth/cmtp/capi.c         |    2 +-
>  9 files changed, 15 insertions(+), 15 deletions(-)

for the Bluetooth part:

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


