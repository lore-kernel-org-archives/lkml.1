Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXKGPEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXKGPEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXKGPES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:04:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbXKGPER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:04:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1194445911.2705.2.camel@albrecht.rdi1.com>
References: <1194445911.2705.2.camel@albrecht.rdi1.com> <200711070644.lA76iodZ005491@agora.fsl.cs.sunysb.edu>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: dhowells@redhat.com, Erez Zadok <ezk@cs.sunysb.edu>,
       akpm@linux-foundation.org, unionfs@filesystems.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Unionfs] Re: [PATCH] IGET: Stop UnionFS from using iget() and read_inode()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 07 Nov 2007 15:04:04 +0000
Message-ID: <30212.1194447844@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Albrecht <albrecht@rdi1.com> wrote:

> Does your test set include readahead-list? I can't get it to work with a
> union mounted filesystem without segfault'ing and kernel oops'ing.

Is that with or without this patch?

David
