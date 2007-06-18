Return-Path: <linux-kernel-owner+w=401wt.eu-S1761668AbXFRLjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668AbXFRLjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXFRLjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:39:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXFRLjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:39:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070615214513.GL3588@stusta.de>
References: <20070615214513.GL3588@stusta.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] net/rxrpc/ar-connection.c: fix NULL dereference
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Mon, 18 Jun 2007 12:37:53 +0100
Message-ID: <22895.1182166673@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> This patch fixes a NULL dereference spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: David Howells <dhowells@redhat.com>
