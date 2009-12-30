Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZL3V5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZL3V5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZL3V5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:57:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbZL3V5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:57:32 -0500
Date: Wed, 30 Dec 2009 13:57:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       uclinux-dev@uclinux.org, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/4] FDPIC: Respect PT_GNU_STACK exec protection
 markings when creating NOMMU stack
Message-Id: <20091230135704.ccd0a129.akpm@linux-foundation.org>
In-Reply-To: <20091222171725.11854.10647.stgit@warthog.procyon.org.uk>
References: <20091222171725.11854.10647.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So these patches and the MN10300 ones didn't get merged.  Presumably
because they're a grabbag of fixes and non-fixes and kinda-fixes with
no particular ordering or precedence and they arrived newly-minted
several days after the release of -rc1.

I could suggest that you go back and sort them into 2.6.33-appropriate
fixes and 2.6.34-appropriate non-fixes.

Or you could try to cook up a good-sounding reason why the whole lot
needs to go into 2.6.33.  If you believe that ;)

