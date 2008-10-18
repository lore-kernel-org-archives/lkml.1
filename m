Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYJRCYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYJRCYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 22:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJRCYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 22:24:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYJRCYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 22:24:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1224280863.7517.2.camel@localhost>
References: <1224280863.7517.2.camel@localhost> <20081017194045.202e6271.sfr@canb.auug.org.au> <Pine.LNX.4.64.0810171346540.685@shark.he.net>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ericvh@gmail.com,
       jaharkes@cs.cmu.edu, airlied@linux.ie
Subject: Re: linux-next: Tree for October 17 (build errors/warnings)
Date: Sat, 18 Oct 2008 03:23:42 +0100
Message-ID: <4525.1224296622@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> 
> This one doesn't have anything to do with my git tree. I'm assuming it
> is related to the credentials patches from David Howells (cced).

You need to include <linux/cred.h> or <linux/sched.h>.

David
