Return-Path: <linux-kernel-owner+w=401wt.eu-S936869AbYEUTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936869AbYEUTCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbYEUTCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:02:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbYEUTCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:02:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080521174203.GG15355@cs181133002.pp.htv.fi>
References: <20080521174203.GG15355@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] frv: export empty_zero_page
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 21 May 2008 19:55:22 +0100
Message-ID: <7195.1211396122@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> EXPORT_SYMBOL_GPL(empty_zero_page);

EXPORT_SYMBOL() as elsewhere please.

I can't test it till I get home next week.

David
