Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbXBEITb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbXBEITb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 03:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXBEITb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 03:19:31 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50522 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752021AbXBEITa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 03:19:30 -0500
Date: Mon, 5 Feb 2007 09:19:26 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20] arch AVR32: Use ARRAY_SIZE macro when
 appropriate
Message-ID: <20070205091926.50fc11d5@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070205024126.GI18118@Ahmed>
References: <20070205023935.GG18118@Ahmed>
	<20070205024126.GI18118@Ahmed>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 04:41:27 +0200
"Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi Haavard,
> 
> A patch to use ARRAY_SIZE macro already defined in linux/kernel.h
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

I'll queue this up for the next merge. Thanks.

Haavard
