Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbXKGQes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbXKGQes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXKGQem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:34:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbXKGQel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:34:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1194448467.3140.6.camel@albrecht.rdi1.com>
References: <1194448467.3140.6.camel@albrecht.rdi1.com> <1194445911.2705.2.camel@albrecht.rdi1.com> <200711070644.lA76iodZ005491@agora.fsl.cs.sunysb.edu> <30212.1194447844@redhat.com>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: dhowells@redhat.com, Erez Zadok <ezk@cs.sunysb.edu>,
       akpm@linux-foundation.org, unionfs@filesystems.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Unionfs] Re: [PATCH] IGET: Stop UnionFS from using iget() and read_inode()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 07 Nov 2007 16:34:27 +0000
Message-ID: <30403.1194453267@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Albrecht <albrecht@rdi1.com> wrote:

> Without ... what's the difference? I asked a specific question about the
> test set that was used to validate unionfs and your fix.  

I was just checking it wasn't something my patch introduced.

David
