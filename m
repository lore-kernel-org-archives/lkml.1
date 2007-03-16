Return-Path: <linux-kernel-owner+w=401wt.eu-S965907AbXCPUxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965907AbXCPUxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965912AbXCPUxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:53:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44864
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965907AbXCPUxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:53:19 -0400
Date: Fri, 16 Mar 2007 13:53:16 -0700 (PDT)
Message-Id: <20070316.135316.115910811.davem@davemloft.net>
To: clameter@sgi.com
Cc: mbligh@mbligh.org, andi@firstfloor.org, rostedt@goodmis.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       chrisw@sous-sol.org, rusty@rustcorp.com.au, glommer@gmail.com,
       apw@shadowen.org
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
	<45FAFD57.90601@mbligh.org>
	<Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 16 Mar 2007 13:48:58 -0700 (PDT)

> Please read my posts to linux-mm on that subject. We discussed it last 
> year in detail and the agreement was that the sparsemem crud needs to be 
> taken out. Kame-san posted patches to do that.

Please don't do that, sparsemem works very well on sparc64 and I
like the flexibility it gives me.

Or are you just proposing to stop using it on x86_64?
