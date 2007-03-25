Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXCYWx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXCYWx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXCYWx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:53:27 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54940 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbXCYWx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:53:26 -0400
Date: Sun, 25 Mar 2007 18:53:10 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [2.6 patch] remove nfs4_acl_add_ace()
Message-ID: <20070325225310.GB8229@fieldses.org>
References: <20070325145832.GL16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325145832.GL16477@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 04:58:32PM +0200, Adrian Bunk wrote:
> nfs4_acl_add_ace() can now be removed.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: J. Bruce Fields <bfields@citi.umich.edu>

--b.
