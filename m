Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbXKNE2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbXKNE2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXKNE2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:28:07 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54168 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbXKNE2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:28:04 -0500
Subject: Re: [PATCH] - [6/15] - remove defconfig ptr comparisons to 0 -
	fs/jfs
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <1195005914.5163.92.camel@localhost>
References: <1195005914.5163.92.camel@localhost>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 22:27:58 -0600
Message-Id: <1195014478.6410.1.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 18:05 -0800, Joe Perches wrote:
> Remove defconfig ptr comparison to 0
> 
> Remove sparse warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

I've added this to the jfs git tree.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

