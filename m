Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbYAVG0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbYAVG0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYAVG0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:26:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44838
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbYAVG0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:26:41 -0500
Date: Mon, 21 Jan 2008 22:26:47 -0800 (PST)
Message-Id: <20080121.222647.34948119.davem@davemloft.net>
To: marcel@holtmann.org
Cc: hidave.darkstar@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       cornelia.huck@de.ibm.com, gombasg@sztaki.hu, htejun@gmail.com,
       viro@zeniv.linux.org.uk, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] bluetooth : move children of connection device to NULL
 before connection down
From: David Miller <davem@davemloft.net>
In-Reply-To: <1200982696.7978.148.camel@aeonflux>
References: <20080121045401.GB4162@darkstar.te-china.tietoenator.com>
	<20080121.031417.171098597.davem@davemloft.net>
	<1200982696.7978.148.camel@aeonflux>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Tue, 22 Jan 2008 07:18:16 +0100

> Right now I can't think of any side effects by this patch. Actually I
> only see an improvement with this patch. So please take it directly and
> starting with next week, I gonna make sure that they are handled again
> properly by me.

Excellent, I'll do that.

Thanks for the feedback.
