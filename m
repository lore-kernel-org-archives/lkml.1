Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZLaLP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZLaLP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 06:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZLaLP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 06:15:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbZLaLPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 06:15:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091230135704.ccd0a129.akpm@linux-foundation.org>
References: <20091230135704.ccd0a129.akpm@linux-foundation.org> <20091222171725.11854.10647.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/4] FDPIC: Respect PT_GNU_STACK exec protection markings when creating NOMMU stack
Date: Thu, 31 Dec 2009 11:15:39 +0000
Message-ID: <24434.1262258139@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> So these patches and the MN10300 ones didn't get merged.  Presumably
> because they're a grabbag of fixes and non-fixes and kinda-fixes with
> no particular ordering or precedence and they arrived newly-minted
> several days after the release of -rc1.
> 
> I could suggest that you go back and sort them into 2.6.33-appropriate
> fixes and 2.6.34-appropriate non-fixes.
> 
> Or you could try to cook up a good-sounding reason why the whole lot
> needs to go into 2.6.33.  If you believe that ;)

I did send them, plus others, during the merge window (albeit near the end).

I then sent this lot after filtering out the extensions that should probably
wait for the next merge window.

David
