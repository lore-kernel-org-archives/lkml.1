Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZFAKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZFAKCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZFAKCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:02:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZFAKCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:02:11 -0400
Date: Mon, 1 Jun 2009 12:02:11 +0200
From: Jan Kara <jack@suse.cz>
To: anees a m <aneesgnu@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de
Subject: Re: JFFS2 filesystem problem
Message-ID: <20090601100211.GD14373@duck.suse.cz>
References: <17cc26190905290122u52e2f9a1q15103557e214883e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17cc26190905290122u52e2f9a1q15103557e214883e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 29-05-09 13:52:05, anees a m wrote:
> Iam uses JFFS2 filesystem for an embedded flash device. But when the power
> is removed i between, the JFFS2 filesystem is corrupted.Resulting in fails.
> Iam able to find that the JFFS2 garbage collector is causing the problem. If
> mounted as READ only, I dont have an issue, but mounting write only is
> resulting in corrupted filesystem some times.
> 
> Unfortunately I need to mount it with read write support.
  I'm not sure why you decided to write to linux-ext4 mailing list, to me
and to Nick. Anyway, the right person for this report seems to be David
Woodhouse who's listed as a maintainer of JFFS2 filesystem.
  Adding him to CC.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
