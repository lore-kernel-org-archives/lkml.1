Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXCIEgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXCIEgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932926AbXCIEgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:36:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53584
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933387AbXCIEgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:36:48 -0500
Date: Thu, 08 Mar 2007 20:36:48 -0800 (PST)
Message-Id: <20070308.203648.55723413.davem@davemloft.net>
To: hpa@zytor.com
Cc: anton@samba.org, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <45F0E309.70403@zytor.com>
References: <45F0E014.8060907@zytor.com>
	<20070308.202718.68040662.davem@davemloft.net>
	<45F0E309.70403@zytor.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 08 Mar 2007 20:31:05 -0800

> The advantage would be that it wouldn't require a v3 for platforms for 
> which MIN_PAGE_SIZE == PAGE_SIZE, which accounts for a very large 
> percentage of systems.
> 
> You still have to look for the darn magic in two places, so there is no 
> reason for it to be different.

Good point.
