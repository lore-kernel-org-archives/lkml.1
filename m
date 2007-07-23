Return-Path: <linux-kernel-owner+w=401wt.eu-S1765783AbXGWIFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765783AbXGWIFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762888AbXGWIDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:03:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:60757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763782AbXGWIDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:03:35 -0400
From: Andi Kleen <ak@suse.de>
To: Jakub Jelinek <jakub@redhat.com>
Subject: Re: vdso.so mislinked by buggy linker was Re: Linus 2.6.23-rc1
Date: Mon, 23 Jul 2007 10:02:19 +0200
User-Agent: KMail/1.9.1
Cc: Andre Noll <maan@systemlinux.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707230156.20276.ak@suse.de> <20070723060339.GN2063@devserv.devel.redhat.com>
In-Reply-To: <20070723060339.GN2063@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231002.20092.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> These options are fairly new, before they were ignored (like all unknown
> -z options).  They were added 2006-05-30 to CVS binutils.
>
> I guess the problem is caused by the gap being too big and old binutils.

Can you think of a workaround Jakub? 

-Andi
