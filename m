Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXGaSgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXGaSgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763714AbXGaSgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:36:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761589AbXGaSgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:36:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200707311940.38742.m.kozlowski@tuxland.pl>
References: <200707311940.38742.m.kozlowski@tuxland.pl> <200707311845.48807.m.kozlowski@tuxland.pl>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 24] include/asm-frv/thread_info.h: kmalloc + memset conversion to kzalloc
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 31 Jul 2007 19:35:54 +0100
Message-ID: <9639.1185906954@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-By: David Howells <dhowells@redhat.com>
