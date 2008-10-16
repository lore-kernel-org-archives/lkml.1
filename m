Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYJPXa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYJPXa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJPXat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:30:49 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:34611 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYJPXas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:30:48 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH vfs-2.6 6/6] vfs: add LOOKUP_RENAME_TARGET intent
References: <e86c95d83e848f673b3120397.ps@mail.parknet.co.jp>
	<ef1e4d933e848f673b4220397.ps@mail.parknet.co.jp>
	<4e71a4b03e848f673b4320397.ps@mail.parknet.co.jp>
	<f5d2a7043e848f673b5420397.ps@mail.parknet.co.jp>
	<e8c7efff3e848f673b5520397.ps@mail.parknet.co.jp>
	<11d623e93e848f673b5620397.ps@mail.parknet.co.jp>
	<20081016152933.ec52ceba.akpm@linux-foundation.org>
Date: Fri, 17 Oct 2008 08:30:39 +0900
In-Reply-To: <20081016152933.ec52ceba.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 16 Oct 2008 15:29:33 -0700")
Message-ID: <87k5c89kyo.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> I put these six patches into my tree for sending to Al when he
> resurfaces.

Thanks. I'm happy with it.

> We're near the end of the merge window and a lot of trees (including
> git-vfs) have a lot of outstanding material:
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
