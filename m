Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbYE1NlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbYE1NlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYE1Nko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:40:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYE1Nkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:40:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0805281614250.26675@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805281614250.26675@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI> <2874.1211980355@redhat.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: dhowells@redhat.com, clameter@sgi.com, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 14:40:25 +0100
Message-ID: <24227.1211982025@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> Thanks for testing! Where do I send these patches though? There's no entry 
> for no-MMU in MAINTAINERS. I guess I could just send them to Andrew...

Andrew and/or Linus.

David
