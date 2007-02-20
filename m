Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXBTLBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXBTLBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932877AbXBTLBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:01:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXBTLBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:01:52 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070220000639.GF13958@stusta.de> 
References: <20070220000639.GF13958@stusta.de> 
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kill net/rxrpc/rxrpc_syms.c 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 20 Feb 2007 10:59:46 +0000
Message-ID: <18861.1171969186@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

>  } /* end rxrpc_create_call() */
> +EXPORT_SYMBOL(rxrpc_create_call);

A blank line between the end of the function and the EXPORT_SYMBOL please.

David
