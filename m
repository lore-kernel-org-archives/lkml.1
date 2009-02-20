Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZBTIY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZBTIY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZBTIXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:23:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbZBTIXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:23:52 -0500
Date: Fri, 20 Feb 2009 00:23:33 -0800 (PST)
Message-Id: <20090220.002333.43185677.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, alexander.h.duyck@intel.com,
       yu.zhao@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 3/5] igb: add pf side of VMDq support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090220043944.29650.38934.stgit@lost.foo-projects.org>
References: <20090220043902.29650.35055.stgit@lost.foo-projects.org>
	<20090220043944.29650.38934.stgit@lost.foo-projects.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 19 Feb 2009 20:39:44 -0800

> Add the pf portion of vmdq support.  This provides enough support so that
> VMDq is enabled, and the pf is functional without enabling vfs.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
