Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbXKNBhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbXKNBhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXKNBhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:37:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60439
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbXKNBhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:37:19 -0500
Date: Tue, 13 Nov 2007 17:37:18 -0800 (PST)
Message-Id: <20071113.173718.112153027.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
References: <20071106195157.878563669@sgi.com>
	<20071113.031510.151440585.davem@davemloft.net>
	<Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


BTW, I'm going to stop testing your patches on sparc64 for
a while until you start to make me feel like you understand
that ignoring the BSS bloat issue is bad.
