Return-Path: <linux-kernel-owner+w=401wt.eu-S965069AbXGMWwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069AbXGMWwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964840AbXGMWv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:51:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59338
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S937765AbXGMWv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:51:58 -0400
Date: Fri, 13 Jul 2007 15:51:57 -0700 (PDT)
Message-Id: <20070713.155157.00926856.davem@davemloft.net>
To: clameter@sgi.com
Cc: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com, jeremy@goop.org
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707131546140.26352@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0707130933140.21777@schroedinger.engr.sgi.com>
	<20070713.154119.15263594.davem@davemloft.net>
	<Pine.LNX.4.64.0707131546140.26352@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 13 Jul 2007 15:50:33 -0700 (PDT)

> Core cpu and node maps exist in the page allocator and are defined in 
> nodemask.h and cpumask.h. I have recently introduced a framework that 
> allows the definition of new masks that could be used in the future to 
> abstract these out of the arches (See the memoryless node patchees). But 
> that work has not been merged yet and is likely going to be a separate 
> project.

Ok.
