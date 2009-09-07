Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbZIGB0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbZIGB0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 21:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbZIGB0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 21:26:42 -0400
Received: from fifo99.com ([67.223.236.141]:60310 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439AbZIGB0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 21:26:41 -0400
Subject: Re: [PATCH 00/12] Gigaset driver patches for 2.6.32
From: Daniel Walker <dwalker@fifo99.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de, Hansjoerg Lipp <hjlipp@web.de>
In-Reply-To: <20090906-patch-gigaset-00.tilman@imap.cc>
References: <20090906-patch-gigaset-00.tilman@imap.cc>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 18:26:46 -0700
Message-Id: <1252286806.2139.1.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 20:58 +0200, Tilman Schmidt wrote:
> Dave,
> 
> following is a series of patches for the Gigaset driver which I would
> appreciate getting merged into kernel release 2.6.32.
> 
> The first one is a bugfix I had already submitted for 2.6.31 but which
> seems to have fallen through the cracks. Please disregard if it's
> already present your tree.
> 
> The next eight patches provide various small bugfixes, error handling
> and documentation improvements.
> 
> The final three patches add an alternative interface to the driver,
> connecting to the Kernel CAPI subsystem instead of the obsolescent
> ISDN4Linux subsystem. They have been presented on the i4ldeveloper
> mailing list and didn't draw any protests. (In fact, no comments at
> all. I'm determined to take that as a positive sign.)
> 
> Would you please take these into your net tree for 2.6.32.

patches 6,7,10, and 12 all have checkpatch errors. Could you fix those? 

Daniel

