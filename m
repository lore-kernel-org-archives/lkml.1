Return-Path: <linux-kernel-owner+w=401wt.eu-S932705Ab0AGAMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab0AGAMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411Ab0AGAMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:12:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0AGAMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:12:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1001061044000.3630@localhost.localdomain>
References: <alpine.LFD.2.00.1001061044000.3630@localhost.localdomain> <20100106172317.25862.64950.stgit@warthog.procyon.org.uk> <20100106172333.25862.40963.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/4] elf_fdpic_core_dump(): fix build break in 2.6.33-rc1
Date: Thu, 07 Jan 2010 00:12:16 +0000
Message-ID: <11214.1262823136@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So a strong NAK to this patch.

Okay, forget that one then.  Can you take the others?

David
