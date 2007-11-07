Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbXKGPN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbXKGPN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXKGPNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:13:49 -0500
Received: from host-66-43-248-10 ([67.55.143.10]:58625 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752293AbXKGPNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:13:48 -0500
Subject: Re: [Unionfs] Re: [PATCH] IGET: Stop UnionFS from using iget() and
	read_inode()
From: Paul Albrecht <albrecht@rdi1.com>
To: David Howells <dhowells@redhat.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       unionfs@filesystems.org, linux-kernel@vger.kernel.org
In-Reply-To: <30212.1194447844@redhat.com>
References: <1194445911.2705.2.camel@albrecht.rdi1.com>
	 <200711070644.lA76iodZ005491@agora.fsl.cs.sunysb.edu>
	 <30212.1194447844@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Nov 2007 09:14:27 -0600
Message-Id: <1194448467.3140.6.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 15:04 +0000, David Howells wrote:
> Paul Albrecht <albrecht@rdi1.com> wrote:
> 
> > Does your test set include readahead-list? I can't get it to work with a
> > union mounted filesystem without segfault'ing and kernel oops'ing.
> 
> Is that with or without this patch?

Without ... what's the difference? I asked a specific question about the
test set that was used to validate unionfs and your fix.  

Paul Albrecht
