Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbZJMCfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbZJMCfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbZJMCfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:35:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757361AbZJMCfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:35:00 -0400
Date: Mon, 12 Oct 2009 19:33:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Howells <dhowells@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mmotm] synchro-test: add missing header file
Message-Id: <20091012193338.256f57b6.akpm@linux-foundation.org>
In-Reply-To: <20091013132454.bbfb4a2e.sfr@canb.auug.org.au>
References: <20091009161042.b301700c.randy.dunlap@oracle.com>
	<200910090830.n998Ubvv020464@imap1.linux-foundation.org>
	<23768.1255344678@redhat.com>
	<20091012162015.9cc24569.akpm@linux-foundation.org>
	<20091013132454.bbfb4a2e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 13:24:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Mon, 12 Oct 2009 16:20:15 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > kernel/synchro-test.c has mysteriously vanished from linux-next so I
> 
> That would be because it was never in linux-next :-)
> 
> See your patch mutex-subsystem-synchro-test-module.patch

geeze, I've been sitting on that for 3-1/2 years.  I wonder how much
use it's getting.

http://userweb.kernel.org/~akpm/mmotm/broken-out/mutex-subsystem-synchro-test-module.patch
