Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZKBQFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZKBQFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZKBQFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:05:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbZKBQFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:05:47 -0500
Date: Mon, 2 Nov 2009 17:05:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: Make use of ARRAY_SIZE.
In-Reply-To: <1257112055-14011-1-git-send-email-tfransosi@gmail.com>
Message-ID: <alpine.LSU.2.00.0911021704580.4203@wotan.suse.de>
References: <1257112055-14011-1-git-send-email-tfransosi@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Nov 2009, Thiago Farina wrote:

> Cleanup the usage of DBE_VT_SIZE since the kernel already defines the
> same macro for the same propose.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/video/sgivwfb.c |    4 ++--
>  include/video/sgivw.h   |   11 +++++------
>  2 files changed, 7 insertions(+), 8 deletions(-)

I have update the changelog with the fact that your patch also cleans up 
the whitespace in the immediate neighbourhood of the changes.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
