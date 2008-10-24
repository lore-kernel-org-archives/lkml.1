Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYJXKJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYJXKJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYJXKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:09:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33167 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYJXKJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:09:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081024165421.1221819a.sfr@canb.auug.org.au>
References: <20081024165421.1221819a.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: Fw: [PATCH] coda: credentials error
Date: Fri, 24 Oct 2008 11:08:19 +0100
Message-ID: <3238.1224842899@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That looks okay.  This could go upstream now as linux/cred.h is already
upstream, even if the other patches aren't yet.

David
