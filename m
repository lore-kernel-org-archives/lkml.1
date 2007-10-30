Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbXJ3DwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbXJ3DwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXJ3Dvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:51:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51898
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbXJ3Dvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:51:52 -0400
Date: Mon, 29 Oct 2007 20:51:50 -0700 (PDT)
Message-Id: <20071029.205150.04488278.davem@davemloft.net>
To: 2500@gmx.de
Cc: pl@dlh.net, sparclinux@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: tcp rfc 2385 security/bugfix for sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710161848.18443.2500@gmx.de>
References: <200710161848.18443.2500@gmx.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Dellweg <2500@gmx.de>
Date: Tue, 16 Oct 2007 18:47:56 +0200

> while reviewing the tcp_md5-related code further i came across with another
> two of these casts which you probably have missed. I don't actually think
> that they impose a problem by now, but as you said we should remove them.

I'll apply this patch, thanks Matthias.
