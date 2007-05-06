Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXEFVSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXEFVSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXEFVSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:18:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbXEFVSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:18:24 -0400
Date: Sun, 6 May 2007 22:18:19 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: Re: [PATCH 1/5] fs: Introduce vfs_path_lookup
Message-ID: <20070506211819.GA13333@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
References: <1178473289617-git-send-email-jsipek@cs.sunysb.edu> <1178473289264-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178473289264-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 01:41:25PM -0400, Josef 'Jeff' Sipek wrote:
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> ---
>  fs/namei.c            |   32 ++++++++++++++++++++++++++++++++
>  include/linux/namei.h |    2 ++
>  2 files changed, 34 insertions(+), 0 deletions(-)

Looks good to me.

