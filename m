Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXCPNkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXCPNkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbXCPNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:40:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39080 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbXCPNkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:40:51 -0400
Date: Fri, 16 Mar 2007 13:40:48 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try #2]
Message-ID: <20070316134048.GA3393@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, davem@davemloft.net,
	netdev@vger.kernel.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org
References: <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 12:50:08PM +0000, David Howells wrote:
>  (*) Make fs/afs/ use it and delete the current contents of net/rxrpc/

Having this done would be a really useful use case for getting the code
merged..

