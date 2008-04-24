Return-Path: <linux-kernel-owner+w=401wt.eu-S1763876AbYDXPlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763876AbYDXPlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758727AbYDXPlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:41:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44902
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753313AbYDXPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:41:45 -0400
Date: Thu, 24 Apr 2008 08:41:44 -0700 (PDT)
Message-Id: <20080424.084144.01839530.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804240837120.2779@woody.linux-foundation.org>
References: <20080424.040239.193699673.davem@davemloft.net>
	<alpine.LFD.1.10.0804240837120.2779@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Apr 2008 08:39:37 -0700 (PDT)

> Heh. This is what x86 has done since day#1. I wonder why other 
> architectures wouldn't have copied that part..

I passed it around in a register because nothing outside of the trap
return and signal handling path needed access to it :-)
