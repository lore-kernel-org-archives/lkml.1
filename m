Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZBTIYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZBTIYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZBTIXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:23:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49550
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbZBTIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:23:45 -0500
Date: Fri, 20 Feb 2009 00:23:26 -0800 (PST)
Message-Id: <20090220.002326.06887003.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, alexander.h.duyck@intel.com,
       yu.zhao@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 2/5] igb: add vfs_allocated_count as
 placeholder for number of vfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090220043922.29650.58034.stgit@lost.foo-projects.org>
References: <20090220043902.29650.35055.stgit@lost.foo-projects.org>
	<20090220043922.29650.58034.stgit@lost.foo-projects.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 19 Feb 2009 20:39:23 -0800

> This is the first step in supporting sr-iov.  The vf_allocated_count value
> will be 0 until we actually have vfs present.  In the meantime it
> represents an offset value for the start of the queues.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
