Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbXIUQOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbXIUQOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXIUQOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:14:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47924
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbXIUQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:14:33 -0400
Date: Fri, 21 Sep 2007 09:14:32 -0700 (PDT)
Message-Id: <20070921.091432.74736040.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: jeff@garzik.org, mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
From: David Miller <davem@davemloft.net>
In-Reply-To: <200709211201.24475.vda.linux@googlemail.com>
References: <200709211201.24475.vda.linux@googlemail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 21 Sep 2007 12:01:24 +0100

> Hi Jeff,

BNX2 and TG3 patches goes through Michael Chan and myself,
and I usually merge them in instead of Jeff.
