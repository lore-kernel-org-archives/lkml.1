Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZBYMhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZBYMhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZBYMgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:36:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47090 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZBYMgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:36:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200902250451.UAA12851@hpdst41.cup.hp.com>
References: <200902250451.UAA12851@hpdst41.cup.hp.com>
To: Justin Chen <jchen@hpdst41.cup.hp.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org, bjorn.helgaas@hp.com,
       justin.chen@hp.com, linux-kernel@vger.kernel.org,
       yasutake.koichi@jp.panasonic.com
Subject: Re: [PATCH 09/15] bitops: Change the bitmap index from int to unsigned long [mn10300]
Date: Wed, 25 Feb 2009 12:34:43 +0000
Message-ID: <14255.1235565283@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Chen <jchen@hpdst41.cup.hp.com> wrote:

> Change the index to unsigned long in all bitops for [mn10300]
> 
> Signed-off-by: Justin Chen <justin.chen@hp.com>
> Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: David Howells <dhowells@redhat.com>
