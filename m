Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYBKQui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYBKQui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYBKQu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:50:28 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41552 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYBKQu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:50:27 -0500
Subject: Re: [PATCH] drivers/base: export gpl (un)register_memory_notifier
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, linux-ppc <linuxppc-dev@ozlabs.org>,
       Thomas Klein <osstklei@de.ibm.com>,
       "Themann, Jan-Bernd" <themann@de.ibm.com>, Greg KH <greg@kroah.com>,
       Christoph Raisch <RAISCH@de.ibm.com>
In-Reply-To: <200802111724.12416.ossthema@de.ibm.com>
References: <200802111724.12416.ossthema@de.ibm.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 08:50:25 -0800
Message-Id: <1202748625.8276.24.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 17:24 +0100, Jan-Bernd Themann wrote:
> Drivers like eHEA need memory notifiers in order to 
> update their internal DMA memory map when memory is added
> to or removed from the system.
> 
> Patch for eHEA memory hotplug support that uses these functions:
> http://www.spinics.net/lists/netdev/msg54484.html
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

How about you fix up the driver, first?  Then, this can go in.

-- Dave

