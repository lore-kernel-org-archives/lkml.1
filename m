Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYJZQLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYJZQLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 12:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYJZQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 12:11:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38825 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbYJZQL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 12:11:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081026225324.6231397d.sfr@canb.auug.org.au>
References: <20081026225324.6231397d.sfr@canb.auug.org.au> <20081025130851.379cfac0.sfr@canb.auug.org.au> <20081024174838.GA24466@us.ibm.com> <11290.1224873841@redhat.com> <10752.1225019273@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Date: Sun, 26 Oct 2008 16:11:20 +0000
Message-ID: <11616.1225037480@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > Those patches aren't likely to change much, and they get hit with LTP
> > regularly.
> 
> They already changed between what I thought was the correct branch and
> what was the correct branch :-)

If you're talking about between James's two creds branches, he did ask you to
pull from the new one - just before you went on holiday, so I suspect you
didn't see it till you got back.

If you're talking about my creds-v3 and creds-v4 branches, the difference was
merge conflicts with Linus, nothing more.  And really, I should just have
thrown the merge on top of creds-v3 rather than trying to maintain my patchset
and producing a creds-v4.  That's one of the reasons I'd like to recreate my
kernel.org tree - to get rid of the unnecessary labels.

David
