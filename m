Return-Path: <linux-kernel-owner+w=401wt.eu-S1030847AbXCHWy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847AbXCHWy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030848AbXCHWyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:54:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030847AbXCHWyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:54:54 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070308224806.17456.13944.stgit@warthog.cambridge.redhat.com> 
References: <20070308224806.17456.13944.stgit@warthog.cambridge.redhat.com> 
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 08 Mar 2007 22:54:32 +0000
Message-ID: <17617.1173394472@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> These patches together supply secure client-side RxRPC connectivity as a Linux
> kernel socket family.  Only the transport/session side is supplied - the
> presentation side (marshalling the data) is left to the client.

The patches can also be downloaded from:

	http://people.redhat.com/~dhowells/rxrpc/01-crypto-kernel-buff.diff
	http://people.redhat.com/~dhowells/rxrpc/02-move-skb-generic.diff
	http://people.redhat.com/~dhowells/rxrpc/03-timers.diff
	http://people.redhat.com/~dhowells/rxrpc/04-keys.diff
	http://people.redhat.com/~dhowells/rxrpc/05-af_rxrpc.diff

David
