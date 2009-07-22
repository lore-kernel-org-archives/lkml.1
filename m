Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbZGVIKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbZGVIKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbZGVIKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:10:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZGVIKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:10:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1248241468.27348.47.camel@pasglop>
References: <1248241468.27348.47.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Arch list <linux-arch@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
Date: Wed, 22 Jul 2009 09:09:34 +0100
Message-ID: <23069.1248250174@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Martin Schwidefsky compile tested on s390 and Michael Ellerman did some
> test builds on ia64, arm, sparc32, sparc64, i386 and x86_64
> 
> Nobody else reacted.

I did tests for MN10300 and FRV.

David
