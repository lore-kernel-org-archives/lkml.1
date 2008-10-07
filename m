Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYJGXJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYJGXJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYJGXJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:09:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35478
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754720AbYJGXI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:08:59 -0400
Date: Tue, 07 Oct 2008 16:08:35 -0700 (PDT)
Message-Id: <20081007.160835.257227518.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: rjw@sisk.pl, arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu,
       netdev@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@tglx.de,
       tytso@mit.edu, linux-ide@vger.kernel.org
Subject: Re: Top kernel oopses/warnings for the week of October 7th, 2008
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081007235833.1a89948f@lxorguk.ukuu.org.uk>
References: <48EBBE15.9030905@linux.intel.com>
	<200810072213.16103.rjw@sisk.pl>
	<20081007235833.1a89948f@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 7 Oct 2008 23:58:33 +0100

> > This should have been fixed by:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f5a6d958b5d0a10e7e7a9dee1862fb31d08c6d26
> 
> You mean - hidden by - that change should IMHO be reverted

Grrr... I totally agree.
