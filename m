Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZGGPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZGGPfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZGGPff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:35:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58186 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZGGPff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:35:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1246976238.3613.27.camel@ht.satnam>
References: <1246976238.3613.27.camel@ht.satnam> <1246975428.3613.10.camel@ht.satnam>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: dhowells@redhat.com, trivial <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/22] trivial: fix typo "has has" in multiple files
Date: Tue, 07 Jul 2009 16:27:23 +0100
Message-ID: <16577.1246980443@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> - * 	acknowledges receipt, i.e. has has a chance to establish any
> + * 	acknowledges receipt, i.e. has a chance to establish any

Should that be just "has", or should it be "has had"?

David
