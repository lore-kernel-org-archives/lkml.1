Return-Path: <linux-kernel-owner+w=401wt.eu-S937525AbYEUUic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937525AbYEUUic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937297AbYEUUiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:38:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39935
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S937515AbYEUUiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:38:01 -0400
Date: Wed, 21 May 2008 13:37:56 -0700 (PDT)
Message-Id: <20080521.133756.240329422.davem@davemloft.net>
To: martin@strongswan.org
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26-rc3] xfrm: Installing NULL encryption IPSec SAs
 fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211388907.26331.10.camel@martin>
References: <1211388907.26331.10.camel@martin>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4LKcmHl031164

From: Martin Willi <martin@strongswan.org>
Date: Wed, 21 May 2008 11:55:06 -0500

> ï»¿Installing NULL encryption IPSec SAs works using the .compat name
> "cipher_null", but fails with the .name "ecp(cipher_null)" due the
> missing check in key length verification. 
> ï»¿
> Signed-off-by: Martin Willi <martin@strongswan.org>

Herbert does this look Ok to you?

Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
