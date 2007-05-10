Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbXEJWJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbXEJWJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759373AbXEJWI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:08:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41882
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759304AbXEJWI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:08:56 -0400
Date: Thu, 10 May 2007 15:08:58 -0700 (PDT)
Message-Id: <20070510.150858.08147592.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: sam@ravnborg.org, cw@f00f.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make modpost section warnings clearer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070510220325.GI29713@flint.arm.linux.org.uk>
References: <20070510.140725.99616053.davem@davemloft.net>
	<20070510215920.GH29713@flint.arm.linux.org.uk>
	<20070510220325.GI29713@flint.arm.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Thu, 10 May 2007 23:03:25 +0100

> Change modpost section mismatch warnings to be less confusing;
> model them on the binutils linker warnings which we all know how
> to interpret.
> 
> Also, fix the wrong ordering of arguments for the final case -
> fromsec and refsymname were reversed.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

FWIW I'm fine with the new wording.
