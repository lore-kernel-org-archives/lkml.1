Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZH0Mcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZH0Mcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZH0Mcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbZH0Mcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:32:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090827120906.14429.94498.stgit@warthog.procyon.org.uk>
References: <20090827120906.14429.94498.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33@lists.infradead.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] AFS: Stop readlink() on AFS crashing because file not passed to afs_readpage()
Date: Thu, 27 Aug 2009 13:32:23 +0100
Message-ID: <14659.1251376343@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Oops - I got the list address wrong; I've sent it again with the right
 address].
