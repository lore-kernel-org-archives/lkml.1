Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbXFRLlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbXFRLlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761216AbXFRLln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:41:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761124AbXFRLlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:41:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070615214520.GM3588@stusta.de>
References: <20070615214520.GM3588@stusta.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] net/rxrpc/ar-output.c: remove dead code
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Mon, 18 Jun 2007 12:40:02 +0100
Message-ID: <22946.1182166802@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> This patch removes dead code spotted by the Coverity checker.

This is the wrong solution.  'copied' should be updated.

David
