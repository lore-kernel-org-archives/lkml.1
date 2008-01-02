Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYABHw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYABHw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 02:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYABHwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 02:52:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59425
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbYABHwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 02:52:21 -0500
Date: Tue, 01 Jan 2008 23:52:20 -0800 (PST)
Message-Id: <20080101.235220.125067261.davem@davemloft.net>
To: gregkh@suse.de
Cc: hidave.darkstar@gmail.com, greg@kroah.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080102070008.GA31343@suse.de>
References: <20080102051828.GA24431@suse.de>
	<20080101.212501.00751091.davem@davemloft.net>
	<20080102070008.GA31343@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Tue, 1 Jan 2008 23:00:08 -0800

> I'm very open to potential patches to do this, just don't ignore the
> issues that others have run into in the past when attempting this.

Fair enough.
