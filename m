Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYCZKkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYCZKkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYCZKjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:39:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38740
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754153AbYCZKjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:39:53 -0400
Date: Wed, 26 Mar 2008 03:39:52 -0700 (PDT)
Message-Id: <20080326.033952.50906563.davem@davemloft.net>
To: mingo@elte.hu
Cc: jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080326102514.GB17176@elte.hu>
References: <20080325131708.GB9612@elte.hu>
	<20080325.160916.182495221.davem@davemloft.net>
	<20080326102514.GB17176@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 26 Mar 2008 11:25:14 +0100

> Or is it your position that every single file in sparc64 is squeaky 
> clean and that each of the 1457 cleanliness problems that checkpatch.pl 
> reported there is bogus?

No but last time I checked sparc64 was one of the few arch's
that build themselves with -Werror.
