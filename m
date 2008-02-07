Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYBGGiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYBGGiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYBGGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:38:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40837
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbYBGGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:38:10 -0500
Date: Wed, 06 Feb 2008 22:38:40 -0800 (PST)
Message-Id: <20080206.223840.267211989.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207063803.GA22563@suse.de>
References: <20080207054738.GB20902@suse.de>
	<20080206.220544.238067538.davem@davemloft.net>
	<20080207063803.GA22563@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 22:38:03 -0800

> I'm guessing that you have a partition that is the whole disk?  That
> would make sense why I and most others haven't seen this yet.

It's an attribute used by Sun disk labels, usually it's the
third partition.

