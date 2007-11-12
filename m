Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXKLXPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXKLXPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbXKLXO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:14:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759570AbXKLXO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:14:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com>
References: <ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com> <20071110181416.31dc2614.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <6214.1194881680@redhat.com> <20071112115353.227f35cb.akpm@linux-foundation.org> 
To: "SL Baur" <steve@xemacs.org>
Cc: dhowells@redhat.com, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 12 Nov 2007 23:14:51 +0000
Message-ID: <17306.1194909291@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SL Baur <steve@xemacs.org> wrote:

> (push '("/Kbuild" . makefile-mode) auto-mode-alist)

Does that work for Kbuild.asm too, more to the point?

David
