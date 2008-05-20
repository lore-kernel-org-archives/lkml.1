Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbYETVdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbYETVdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760790AbYETVd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:33:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43362
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760397AbYETVd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:33:26 -0400
Date: Tue, 20 May 2008 14:33:21 -0700 (PDT)
Message-Id: <20080520.143321.97817925.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6] [NET] The world is not perfect patch.
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0805200229r6fb2daa1w50aaffa9b130f89f@mail.gmail.com>
References: <eb3ff54b0805200229r6fb2daa1w50aaffa9b130f89f@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Tue, 20 May 2008 12:29:26 +0300

> There are three methods in the network stack which start with
> #ifndef I_WISH_WORLD_WERE_PERFECT.

I think it is better to delete this code.  It is impossible
for anyone to build test it without making source modifications,
therefore it will continute to break over and over again over
time.
