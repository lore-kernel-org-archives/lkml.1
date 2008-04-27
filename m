Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbYD0Tus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbYD0Tus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762952AbYD0Tui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:50:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51353
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762747AbYD0Tuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:50:37 -0400
Date: Sun, 27 Apr 2008 12:50:37 -0700 (PDT)
Message-Id: <20080427.125037.27605058.davem@davemloft.net>
To: cooloney@kernel.org
Cc: viro@zeniv.linux.org.uk, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin checksum annotations
From: David Miller <davem@davemloft.net>
In-Reply-To: <386072610804270637n68478a63mab9935fb935aaab5@mail.gmail.com>
References: <20080427111623.GA6754@osiris.boeblingen.de.ibm.com>
	<20080427124247.GV5882@ZenIV.linux.org.uk>
	<386072610804270637n68478a63mab9935fb935aaab5@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Bryan Wu" <cooloney@kernel.org>
Date: Sun, 27 Apr 2008 21:37:15 +0800

> Sorry for the delay. I will test this patch on Blackfin arch. And if it is ok,
> it will be merged to Blackfin git tree. As long as it is a Blackfin
> arch related issue,
> merging to Blackfin tree is a better way.

Fair enough, I'll drop it from net-2.6

Thanks.
