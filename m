Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZKCTXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZKCTXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZKCTXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:23:20 -0500
Received: from mail.deathmatch.net ([72.66.92.28]:4780 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZKCTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:23:19 -0500
Date: Tue, 3 Nov 2009 14:21:39 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       linux-karma-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/27] BKL: Remove BKL from omfs
Message-ID: <20091103192139.GA10464@hash.localnet>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-22-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257156307-24175-22-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:05:01AM +0100, Jan Blunck wrote:
> BKL is only used in fill_super. It is safe to remove it.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/omfs/inode.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)

This patch and omfs parts of 1:
Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

