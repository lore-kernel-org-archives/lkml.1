Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbXJ2Nkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbXJ2Nkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXJ2Nkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:40:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbXJ2Nki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:40:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0710290925001.11882@localhost.localdomain>
References: <Pine.LNX.4.64.0710290925001.11882@localhost.localdomain>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FRV: Move DMA macros to scatterlist.h for consistency.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 29 Oct 2007 13:40:33 +0000
Message-ID: <10838.1193665233@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day <rpjday@crashcourse.ca> wrote:

> To be consistent with other architectures, these two DMA macros should
> be defined in scatterlist.h as opposed to dma-mapping.h

Why have you discarded the comment?

David
