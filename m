Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbXJ2Esu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbXJ2Esu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbXJ2EsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:48:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38576
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbXJ2EsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:48:12 -0400
Date: Sun, 28 Oct 2007 21:48:14 -0700 (PDT)
Message-Id: <20071028.214814.243867224.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SUNRPC] endianness annotations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071029043758.GZ8181@ftp.linux.org.uk>
References: <20071029043758.GZ8181@ftp.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 29 Oct 2007 04:37:58 +0000

> rpcrdma stuff lacks endianness annotations for on-the-wire data.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>
