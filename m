Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbXEIUtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbXEIUtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbXEIUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:49:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40490
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758770AbXEIUtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:49:31 -0400
Date: Wed, 09 May 2007 13:49:32 -0700 (PDT)
Message-Id: <20070509.134932.122941737.davem@davemloft.net>
To: mark@mtfhpc.demon.co.uk
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/sunzilog: Interrupt enable before ISR
 handler installed
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.61.0705091858490.29173@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0704292250290.1747@mtfhpc.demon.co.uk>
	<20070507.162042.38710851.davem@davemloft.net>
	<Pine.LNX.4.61.0705091858490.29173@mtfhpc.demon.co.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date: Wed, 9 May 2007 19:17:29 +0100 (BST)

> Hi all,
> 
> I have added a from line, comment and signed-off-by line to the attached 
> patch file.

Patch applied, thanks Mark.
