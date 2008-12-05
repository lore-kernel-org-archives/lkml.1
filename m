Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYLEKsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYLEKsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYLEKsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:48:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYLEKsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:48:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081205030806.32225.66382.stgit@marcab.local.tull.net>
References: <20081205030806.32225.66382.stgit@marcab.local.tull.net>
To: Nick Andrew <nick@nick-andrew.net>
Cc: dhowells@redhat.com, David Woodhouse <David.Woodhouse@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, James Morris <jmorris@namei.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in fs.c
Date: Fri, 05 Dec 2008 10:47:51 +0000
Message-ID: <16075.1228474071@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew <nick@nick-andrew.net> wrote:

> Fix incorrect use of loose in fs.c
> 
> It should be 'lose', not 'loose'. Also fix a spelling error.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Acked-by: David Howells <dhowells@redhat.com>
