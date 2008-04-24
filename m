Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbYDXCOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbYDXCOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYDXCNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:13:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59527
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbYDXCNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:13:52 -0400
Date: Wed, 23 Apr 2008 19:13:54 -0700 (PDT)
Message-Id: <20080423.191354.193690900.davem@davemloft.net>
To: dhaval@linux.vnet.ibm.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, vatsa@in.ibm.com,
       dmitry.adamushko@gmail.com, efault@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] sched: higher granularity load on 64bit
 systems
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080424015814.GA17190@linux.vnet.ibm.com>
References: <1208988476.2849.8.camel@lappy>
	<20080423.172710.152976766.davem@davemloft.net>
	<20080424015814.GA17190@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date: Thu, 24 Apr 2008 07:28:14 +0530

> and I was able to reproduce your group scheduler hang (or so i
> think, it might a separate one altogether.)

I think it's likely the same problem as the one I'm seeing here.
