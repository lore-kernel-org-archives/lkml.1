Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238Ab0ADFnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0ADFnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824Ab0ADFni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:43:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51831
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab0ADFnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:43:33 -0500
Date: Sun, 03 Jan 2010 21:43:37 -0800 (PST)
Message-Id: <20100103.214337.226743566.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: petkan@users.sourceforge.net, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: test off by one
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B37D000.6070009@gmail.com>
References: <4B37D000.6070009@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 27 Dec 2009 22:22:08 +0100

> With `while (i++ < MII_TIMEOUT)' i reaches MII_TIMEOUT + 1 after the loop
> This is probably unlikely a problem in practice.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.
