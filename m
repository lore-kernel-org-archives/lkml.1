Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXJaG6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXJaG6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXJaG6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:58:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46083
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbXJaG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:58:05 -0400
Date: Tue, 30 Oct 2007 23:58:04 -0700 (PDT)
Message-Id: <20071030.235804.99443518.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_key: suppress a warning for 64k pages.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071031162452.fcea4431.sfr@canb.auug.org.au>
References: <20071031153422.44f864e8.sfr@canb.auug.org.au>
	<20071030.214219.256397507.davem@davemloft.net>
	<20071031162452.fcea4431.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 31 Oct 2007 16:24:52 +1100

> On PowerPC allmodconfig build we get this:
> 
> net/key/af_key.c:400: warning: comparison is always false due to limited range of data type
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks Stephen.
