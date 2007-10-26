Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbXJZMVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbXJZMVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXJZMVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:21:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:49350 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbXJZMVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=qe2brBvE9Sy367sc/lcuCVUv79vvXV6C17xt1X0dUU1FxMuqzUv+LKjl0EOjWLsbX6lyQDnhuMB3ZaUsM+iQxxee6fY7hKW5GbAtqIKaOTMnOidqZMD6XIRMzKRDVrZj6QPClRf1SrrGG7PkqvHeoXXrxodRX/aGfU5s+fbI1Jo=
Message-ID: <84144f020710260521p1b785db2yc63af406e75515c9@mail.gmail.com>
Date: Fri, 26 Oct 2007 15:21:39 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: revoke (Was: -mm merge plans for 2.6.24)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e93fe5a28624ba9c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > revoke-special-mmap-handling.patch
> > revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
> > revoke-core-code.patch
> > slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
> > revoke-support-for-ext2-and-ext3.patch
> > revoke-add-documentation.patch
> > revoke-wire-up-i386-system-calls.patch
> > fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
> > fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
> > revoke-vs-git-block.patch
> >
> >   Not sure - opinions sought.

On 10/2/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Needs more work to fix problems raised by viro. I am cooking up a
> patch but it won't be ready for 2.6.24.

FYI the patches (with known bugs) can be found here in case anyone is
interested:

http://www.kernel.org/pub/linux/kernel/people/penberg/patches/revoke/2.6.24-rc1/

                                          Pekka
