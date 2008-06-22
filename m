Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYFVOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYFVOz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYFVOzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:55:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:61159 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYFVOzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kXDFVNFyrVGoQM+iW4TN091PrDkOh6EK2yYb12qrnco7zqpW09ZDViMfda5ISJDiav
         ASQMLlzlBBnZ7gInFu0QFa1JQMXZIjLeGjfPtnnkA2Ci/gKqs2BsQ27los2/f2fIFr9B
         kZQ8lBngZewh904wLTSepB85XiQ32Xv0Tx+Yo=
Message-ID: <cd73a99e0806220755t417c581euf86e893c299bc6de@mail.gmail.com>
Date: Sun, 22 Jun 2008 16:55:17 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 3/3] MTD: atmel_nand can be modular
Cc: "David Woodhouse" <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "David Brownell" <dbrownell@users.sourceforge.net>
In-Reply-To: <1213948112-22348-3-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213948112-22348-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1213948112-22348-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1213948112-22348-3-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Haavard,

> There's no reason to prevent the Atmel NAND driver from
> building as a module.

Acked-by: Andrew Victor <linux@maxim.org.za>
