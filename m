Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYDSGLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYDSGLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbYDSGLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:11:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58519
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758185AbYDSGL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:11:27 -0400
Date: Fri, 18 Apr 2008 23:11:28 -0700 (PDT)
Message-Id: <20080418.231128.97404791.davem@davemloft.net>
To: paulus@samba.org
Cc: jochen@scram.de, sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, scottwood@freescale.com,
       i2c@lm-sensors.org, khali@linux-fr.org
Subject: Re: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF
 helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <18441.33181.511355.338428@cargo.ozlabs.ibm.com>
References: <18441.28496.84724.411784@cargo.ozlabs.ibm.com>
	<20080418.210933.01471700.davem@davemloft.net>
	<18441.33181.511355.338428@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Sat, 19 Apr 2008 15:22:37 +1000

> David Miller writes:
> > From: Paul Mackerras <paulus@samba.org>
> > Date: Sat, 19 Apr 2008 14:04:32 +1000
> > 
> > It's OK if this breaks the sparc64 allmodconfig build, I'll take
> > care of this once it's merged in.
> 
> It breaks the sparc32 allmodconfig build, which seems to be a
> concern.  How do you suggest we fix that?

I'll fix both sparc64 and sparc32 builds when I merge my sparc
tree in.
