Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYGRLDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYGRLDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYGRLDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:03:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbYGRLDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:03:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080716135358.GA1213@tv-sign.ru>
References: <20080716135358.GA1213@tv-sign.ru>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] coredump: make the coredumping process visible to oom kill
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 18 Jul 2008 12:02:12 +0100
Message-ID: <16025.1216378932@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote:

> I am worried the recent changes can break elf_fdpic_core_dump(), I can't
> test it. Hopefully, in that case the fixes should be trivial.

I can't apply your patch 2/2.  Is there another patch missing?

David
