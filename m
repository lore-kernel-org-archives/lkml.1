Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYETRtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYETRtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYETRtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:49:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbYETRtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:49:10 -0400
Date: Tue, 20 May 2008 10:49:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
Message-Id: <20080520104907.e77ae05d.akpm@linux-foundation.org>
In-Reply-To: <4832C7FF.2090904@yandex.ru>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
	<1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>
	<20080507002345.831bc379.akpm@linux-foundation.org>
	<48218F21.4090304@yandex.ru>
	<20080507083835.6ba126e6.akpm@linux-foundation.org>
	<4832C7FF.2090904@yandex.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 15:45:51 +0300 Artem Bityutskiy <dedekind@yandex.ru> wrote:

> Andrew,
> 
> Andrew Morton wrote:
> > I already added gti-ubifs.patch to the -mm lineup.  I haven't yet tried
> > pulling, merging or compiling it.
> 
> is it OK for you if ubifs-2.6.git will have some patches which ubi-2.6.git
> also contains. Will your -mm system handle this?

It happens occasionally and I usually manage to work it out.  Sometimes
with git hackery, sometimes manually.  It'd be better if it was a
once-off thing, rather than having new conflicts arise each time I
repull the trees, if possible.

