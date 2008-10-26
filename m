Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYJZLIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYJZLIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYJZLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:08:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbYJZLIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:08:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081025130851.379cfac0.sfr@canb.auug.org.au>
References: <20081025130851.379cfac0.sfr@canb.auug.org.au> <20081024174838.GA24466@us.ibm.com> <11290.1224873841@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Date: Sun, 26 Oct 2008 11:07:53 +0000
Message-ID: <10752.1225019273@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> It would be good if you could have a "next" (or "creds-next" or
> something) branch in your tree and I can fetch that (that way I don't
> have to keep updating my configs).  It is OK if thet branch rebases and
> may just be an alias for another branch (or a subset if you have
> experimental stuff in there.  Remember "posted, reviewed, tested before
> it is in linux-next".

Those patches aren't likely to change much, and they get hit with LTP
regularly.

What base for the patches?  Linus's head?

David
