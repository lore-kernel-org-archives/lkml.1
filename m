Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYJOVnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYJOVnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYJOVna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:43:30 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:39891 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYJOVn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:43:29 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] vfs: remove LOOKUP_PARENT from non LOOKUP_PARENT lookup
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	<524881153e848f5f6f3426623.ps@mail.parknet.co.jp>
	<f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp>
	<20081015194434.GC24892@infradead.org>
Date: Thu, 16 Oct 2008 06:43:26 +0900
In-Reply-To: <20081015194434.GC24892@infradead.org> (Christoph Hellwig's
	message of "Wed, 15 Oct 2008 15:44:34 -0400")
Message-ID: <87od1lmt4x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Makes sense to me, but in this area you really need to work against
> Al's vfs.git tree as there's quite some work going on.

I'll send updated patchset soon for vfs-2.6. Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
