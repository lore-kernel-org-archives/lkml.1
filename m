Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbYHIHaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbYHIHaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYHIHaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:30:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36922
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753233AbYHIHaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:30:07 -0400
Date: Sat, 09 Aug 2008 00:30:08 -0700 (PDT)
Message-Id: <20080809.003008.114527043.davem@davemloft.net>
To: bunk@kernel.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, david-b@pacbell.net
Subject: Re: [15/17] sparc64: use bcd2bin/bin2bcd
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080808163458.GV14495@cs181140183.pp.htv.fi>
References: <20080808163458.GV14495@cs181140183.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Fri, 8 Aug 2008 19:34:58 +0300

> This patch changes sparc64 to use the new bcd2bin/bin2bcd functions 
> instead of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
