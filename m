Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYFVOuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYFVOuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYFVOuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:50:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:57638 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbYFVOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DxffS5HmcsgZ1z9ADUGyFuEbRHBpiyumXmStJ5wIfqhlXf1nZS9h288crXJSyb7iU2
         AS4Z7SScsJ0MuCK2lyitAR0zWRxsv7sXcBexpL80zu9pSiB8qMH6lpMV4uWBfUpfDS2j
         YDT+7ybEEA1URcCWFcAk/JdL/bfWhAJcwwbVM=
Message-ID: <cd73a99e0806220750i2ac74193ke02dff14f1d78dc3@mail.gmail.com>
Date: Sun, 22 Jun 2008 16:50:08 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 1/3] atmel_nand speedup via {read,write}s{b,w}()
Cc: "David Woodhouse" <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       "David Brownell" <dbrownell@users.sourceforge.net>
In-Reply-To: <1213948112-22348-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213948112-22348-1-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Haavard,

> This uses __raw_{read,write}s{b,w}() primitives to access data on NAND
> chips for more efficient I/O.

This patch of David's has been in the AT91 tree for a while now.

So,
  Acked-by: Andrew Victor <linux@maxim.org.za>


Regards,
  Andrew
