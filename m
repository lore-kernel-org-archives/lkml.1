Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZGCOlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZGCOlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZGCOlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:41:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZGCOlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:41:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090703142250.GB31538@fieldses.org>
References: <20090703142250.GB31538@fieldses.org> <20090702203937.GA10504@fieldses.org> <20090702133532.28297.89635.stgit@warthog.procyon.org.uk> <575.1246570293@redhat.com> <20090702230955.GB12376@fieldses.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, steved@redhat.com, rasmus@msconsult.dk,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFSD: Don't hold unrefcounted creds over call to nfsd_setuser()
Date: Fri, 03 Jul 2009 15:41:26 +0100
Message-ID: <31545.1246632086@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> Also: the problem was introduced by
> 745ca2475a6ac596e3d8d37c2759c0fbe2586227, right?

Yes.

David
