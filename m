Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZHXFzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZHXFzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 01:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZHXFzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 01:55:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60199
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbZHXFzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 01:55:46 -0400
Date: Sun, 23 Aug 2009 22:55:59 -0700 (PDT)
Message-Id: <20090823.225559.62651309.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net
Subject: Re: [PATCH v2 1/1] NET: llc, zero sockaddr_llc struct
From: David Miller <davem@davemloft.net>
In-Reply-To: <1251092619-3368-1-git-send-email-jirislaby@gmail.com>
References: <20090823.185617.36449822.davem@davemloft.net>
	<1251092619-3368-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Mon, 24 Aug 2009 07:43:39 +0200

> sllc_arphrd member of sockaddr_llc might not be changed. Zero sllc
> before copying to the above layer's structure.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied, thanks Jiri.
