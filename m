Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYE0IwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYE0IwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbYE0IwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:52:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805AbYE0IwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:52:14 -0400
Date: Tue, 27 May 2008 01:51:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Pagecache usage optimization on
 pagesize!=blocksize environment
Message-Id: <20080527015135.561eeb6d.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20080527172732.05447770@172.19.0.2>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
	<20080521001930.202446eb.akpm@linux-foundation.org>
	<6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
	<20080522010355.32590474.akpm@linux-foundation.org>
	<6.0.0.20.2.20080527172732.05447770@172.19.0.2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 17:38:34 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> I cleaned up and simplified block_is_partially_uptodate.
> Following patch is for linux-2.6.26-rc4.
> Please review my patch.

We seem to have lost the changelog which means that the patch can't go
much further and it makes it considerably harder for people to review
the patch.

Please maintain the changelog alongside the patch and resend it (possibly after
suitable updates) along with each iteration of the patch.

Thanks.
