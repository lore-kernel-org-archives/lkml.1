Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYIWXsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYIWXsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYIWXr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:47:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47702
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbYIWXr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:47:57 -0400
Date: Tue, 23 Sep 2008 16:47:45 -0700 (PDT)
Message-Id: <20080923.164745.12711639.davem@davemloft.net>
To: jkosina@suse.cz
Cc: jeffrey.t.kirsher@intel.com, jeff@garzik.org, mingo@elte.hu,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       bruce.w.allan@intel.com
Subject: Re: [PATCH 2/3] e1000e: Useset_memory_ro()/set_memory_rw() to
 protect flash memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0809240142030.27884@twin.jikos.cz>
References: <20080923224535.6869.76210.stgit@jtkirshe-mobile.jf.intel.com>
	<20080923.162957.141669474.davem@davemloft.net>
	<Pine.LNX.4.64.0809240142030.27884@twin.jikos.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, 24 Sep 2008 01:45:53 +0200 (CEST)

> Yes, probably not a vanilla kernel material, but could be very well used 
> for testing to further isolate whether it is kernel or userspace 
> corrupting the memory mapped eeprom.

Absolutely.
