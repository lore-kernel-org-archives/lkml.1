Return-Path: <linux-kernel-owner+w=401wt.eu-S965154AbXCPOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbXCPOX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965138AbXCPOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:23:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965119AbXCPOX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:23:27 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070316151305.04cbc352@lxorguk.ukuu.org.uk> 
References: <20070316151305.04cbc352@lxorguk.ukuu.org.uk>  <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com> 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try #2] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 16 Mar 2007 14:23:13 +0000
Message-ID: <25571.1174054993@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> If your messages are datagrams and unreliable -> SOCK_DGRAM

Nope.

> If your messages are datagrams and reliable -> SOCK_RDM

Nope.

> If your messages are datagrams, reliable and ordered -> SOCK_SEQPACKET

Nope.

> If your messages are streams of bits, reliable and ordered -> SOCK_STREAM

Nope.

David
