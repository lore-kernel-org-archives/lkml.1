Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201Ab0BQKD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:03:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174Ab0BQKDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:03:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100212145830I.fujita.tomonori@lab.ntt.co.jp>
References: <20100212145830I.fujita.tomonori@lab.ntt.co.jp>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] frv: remove the obsolete and unnecessary DMA API comments
Date: Wed, 17 Feb 2010 10:03:42 +0000
Message-ID: <28355.1266401022@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> pci_dma_sync_single was obsoleted long ago.
> 
> All the comments are generic, not architecture specific, simply
> describes some of the DMA-API (and frv has the same comments in three
> files). Documentation/DMA-API.txt have more detailed descriptions.
> 
> This removes the above obsolete and unnecessary DMA API
> comments. Let's describe the DMA API in only
> Documentation/DMA-API.txt.

I'm okay with this, _provided_ you put a pointer in a banner comment at the
top of the file to Documentation/DMA-API.txt.

David
