Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbXFSGau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbXFSGau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbXFSGal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:30:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54006
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbXFSGak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:30:40 -0400
Date: Mon, 18 Jun 2007 23:30:58 -0700 (PDT)
Message-Id: <20070618.233058.03094051.davem@davemloft.net>
To: dhowells@redhat.com
Cc: bunk@stusta.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] AF_RXRPC: Return the number of bytes buffered in
 rxrpc_send_data()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070618115236.23639.71608.stgit@warthog.cambridge.redhat.com>
References: <20070618115236.23639.71608.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 18 Jun 2007 12:52:36 +0100

> Return the number of bytes buffered in rxrpc_send_data().
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Patch applied, thanks a lot David.
