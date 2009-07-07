Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbZGGPiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbZGGPiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZGGPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:37:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbZGGPhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:37:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1246976375.3613.30.camel@ht.satnam>
References: <1246976375.3613.30.camel@ht.satnam> <1246975428.3613.10.camel@ht.satnam>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: dhowells@redhat.com, trivial <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/22] trivial: fix typo "on on" in multiple files
Date: Tue, 07 Jul 2009 16:29:40 +0100
Message-ID: <16605.1246980580@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> - * The type of reading going on on this chip
> + * The type of reading going on this chip

Nak.  I think "going on" is a compound verb here, so "going on on this chip"
is very probably correct.

David
