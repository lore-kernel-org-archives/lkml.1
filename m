Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZDTUXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZDTUXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZDTUXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:23:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41740 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbZDTUXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:23:01 -0400
Subject: Re: [PATCH] filesystems: start using roundup_to_blocksize and
 bytes_to_blocks
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1240254435.7068.43.camel@norville.austin.ibm.com>
References: <49EB7087.70302@gmail.com>  <49EB72A3.3060902@gmail.com>
	 <1240254435.7068.43.camel@norville.austin.ibm.com>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 15:22:56 -0500
Message-Id: <1240258976.7068.45.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 14:07 -0500, Dave Kleikamp wrote:
> Looks good from a jfs perspective.  Really cleans up that code.
> 
> On Sun, 2009-04-19 at 20:51 +0200, Marcin Slusarz wrote:
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Sorry.  Should be acked-by rather than signed-off-by, and I really
didn't need to quote the whole patch.  Blame it on Monday.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

