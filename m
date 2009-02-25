Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbZBYXpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbZBYXpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763423AbZBYXpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:45:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763375AbZBYXpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:45:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200902252003.MAA12219@hpdst41.cup.hp.com>
References: <200902252003.MAA12219@hpdst41.cup.hp.com>
To: Justin Chen <jchen@hpdst41.cup.hp.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org, bjorn.helgaas@hp.com,
       justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15 v2] bitops: Change the bitmap index from int to unsigned long [frv]
Date: Wed, 25 Feb 2009 23:42:55 +0000
Message-ID: <7298.1235605375@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Chen <jchen@hpdst41.cup.hp.com> wrote:

> Change the index to be unsigned long in all bitops for [frv]
> 
> Signed-off-by: Justin Chen <justin.chen@hp.com>
> Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: David Howells <dhowells@redhat.com>
