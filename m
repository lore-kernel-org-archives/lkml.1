Return-Path: <linux-kernel-owner+w=401wt.eu-S934066AbXCTUWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbXCTUWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934067AbXCTUWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:22:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934066AbXCTUWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:22:46 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070320211405.3e1d2305@lxorguk.ukuu.org.uk> 
References: <20070320211405.3e1d2305@lxorguk.ukuu.org.uk>  <20070320195856.12853.63473.stgit@warthog.cambridge.redhat.com> 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try #3] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 20 Mar 2007 20:22:25 +0000
Message-ID: <13367.1174422145@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Some of them don't seem to be making it through to the list and are
> dropped each time btw

Yeah.  It's a size issue.  The fifth patch is a third of a megabyte.  The
patches at the URLs should now be updated (I'd forgotten to do that before
sending the emails).

David
