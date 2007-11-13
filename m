Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXKMK5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXKMK5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXKMK5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:57:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXKMK5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:57:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ed10ee420711121909y3e0f84d0hd07c331a9a0aba66@mail.gmail.com>
References: <ed10ee420711121909y3e0f84d0hd07c331a9a0aba66@mail.gmail.com> <20071110181416.31dc2614.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <6214.1194881680@redhat.com> <20071112115353.227f35cb.akpm@linux-foundation.org> <ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com> <17306.1194909291@redhat.com> 
To: "SL Baur" <steve@xemacs.org>
Cc: dhowells@redhat.com, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 13 Nov 2007 10:57:31 +0000
Message-ID: <18662.1194951451@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SL Baur <steve@xemacs.org> wrote:

> Please take the emacsism out of the file as it bothers Andrew and others.

I thought Andrew said it didn't bother him.  I assume he was curious.

David
