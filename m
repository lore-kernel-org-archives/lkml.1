Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbXCTUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbXCTUJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934051AbXCTUJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:09:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52884 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932960AbXCTUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:09:20 -0400
Date: Tue, 20 Mar 2007 21:12:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org,
       dhowells@redhat.com
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try
 #3]
Message-ID: <20070320211222.62dae706@lxorguk.ukuu.org.uk>
In-Reply-To: <20070320195856.12853.63473.stgit@warthog.cambridge.redhat.com>
References: <20070320195856.12853.63473.stgit@warthog.cambridge.redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  (*) SOCK_RPC has been removed.  AF_RXRPC sockets now simply ignore the "type"
>      argument to socket().

This is also incorrect

NAK

