Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXJ2PXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXJ2PXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXJ2PXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:23:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbXJ2PXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:23:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0710290945130.12985@localhost.localdomain>
References: <Pine.LNX.4.64.0710290945130.12985@localhost.localdomain>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FRV: Move DMA macros to scatterlist.h for consistency.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 29 Oct 2007 15:23:41 +0000
Message-ID: <16285.1193671421@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day <rpjday@crashcourse.ca> wrote:

> To be consistent with other architectures, these two DMA macros should
> be defined in scatterlist.h as opposed to dma-mapping.h
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Acked-by: David Howells <dhowells@redhat.com>
