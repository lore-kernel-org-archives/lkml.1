Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbXD0Dvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbXD0Dvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 23:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXD0Dvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 23:51:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38256
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755246AbXD0Dvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 23:51:31 -0400
Date: Thu, 26 Apr 2007 20:51:39 -0700 (PDT)
Message-Id: <20070426.205139.77239500.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH -mm] consolidate asm/const.h to linux/const.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070426205008.73a4075e.randy.dunlap@oracle.com>
References: <20070426205008.73a4075e.randy.dunlap@oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 26 Apr 2007 20:50:08 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make a global linux/const.h header file instead of having multiple,
> per-arch files, and convert current users of asm/const.h to use
> linux/const.h.
> 
> Built on x86_64 and sparc64.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
