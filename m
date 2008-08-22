Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYHVRm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYHVRm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYHVRmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:42:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:62543 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYHVRmt (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tj5aB7BT5UTG56KqTP6t/XAjznFMCbGZ2krDil6XQuinYKKwB9hVMbZpx1EE6nv6iQ
         IC41lx2/nYJ/3GpFa1pNX7UuF11MjDopPyiHhDlll4MURxDBmddLo7x+EzR1RkzeAeDg
         M7FsE5L7zqW6qrnyL/ElI7MmujbHbpeCSLlXQ=
Message-ID: <6934efce0808221042u6d0c21eft6f8cdf67f0217a85@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:42:47 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
Cc: "Arnd Bergmann" <arnd@arndb.de>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AEF976.1010705@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD0101.4020505@gmail.com> <48AE19AD.1020209@lougher.demon.co.uk>
	 <6934efce0808212005h30fa16d8w48833e8a0becfd8c@mail.gmail.com>
	 <200808221852.38950.arnd@arndb.de>
	 <48AEF976.1010705@lougher.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Squashfs and AXFS should be seen as complementary filesystems, and there
> should be room in the Linux kernel for both.

Exactly.  We had different design assumptions.  One is not _better_
than the other, they are just different.
