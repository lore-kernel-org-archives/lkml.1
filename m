Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0BDEQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:16:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35928
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497Ab0BDEQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:16:54 -0500
Date: Wed, 03 Feb 2010 20:17:07 -0800 (PST)
Message-Id: <20100203.201707.248567328.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: isdn@linux-pingi.de, isdn4linux@listserv.isdn4linux.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN: positive error return should be negative in
 mode_hfcmulti()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B62B100.9090308@gmail.com>
References: <4B62B100.9090308@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Fri, 29 Jan 2010 10:57:20 +0100

> The error return should be negative. Its only caller that acts upon its return,
> handle_bmsg(), transmits the positive error but can also return negative errors.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.
