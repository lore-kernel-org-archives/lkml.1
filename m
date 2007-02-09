Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbXBIXrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbXBIXrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXBIXrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:47:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39442
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbXBIXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:47:15 -0500
Date: Fri, 09 Feb 2007 15:47:14 -0800 (PST)
Message-Id: <20070209.154714.97294609.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix misannotation of linkinfo_dn
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1HFaFi-0004Nh-3I@ZenIV.linux.org.uk>
References: <E1HFaFi-0004Nh-3I@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 18:13:42 +0000

> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  include/linux/dn.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Also applied, thanks Al.
