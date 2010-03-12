Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab0CLIue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:50:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33278
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678Ab0CLIub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:50:31 -0500
Date: Fri, 12 Mar 2010 00:50:51 -0800 (PST)
Message-Id: <20100312.005051.09912332.davem@davemloft.net>
To: avi@redhat.com
Cc: ying.huang@intel.com, akpm@linux-foundation.org,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with
 gas 2.16.1
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B99FF0A.1030700@redhat.com>
References: <4B99FD4D.4090206@redhat.com>
	<20100312.004202.27822414.davem@davemloft.net>
	<4B99FF0A.1030700@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>
Date: Fri, 12 Mar 2010 10:44:58 +0200

> Strange, that people can install a new kernel, but not a new
> assembler.

Someone shouldn't have to upgrade their tools to build the
kernel.

And we work very hard to make sure this is the case except
in the most unavoidable situations.
