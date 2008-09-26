Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYIZN2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYIZN2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIZN16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:27:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYIZN15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:27:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
References: <1222426580.16700.258.camel@lappy.programming.kicks-ass.net> <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       nico@cam.org, linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
Date: Fri, 26 Sep 2008 14:27:33 +0100
Message-ID: <10756.1222435653@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Didn't you forget to remove the old one?

Ah...  I did remove the old one... it's just that someone also moved the old
one to arch/arm/include and GIT's merge tool didn't notice.

David
