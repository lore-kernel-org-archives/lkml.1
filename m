Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbYEVAss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbYEVAss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYEVAsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:48:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934661AbYEVAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:48:12 -0400
Date: Wed, 21 May 2008 17:48:08 -0700 (PDT)
Message-Id: <20080521.174808.15066525.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6] [NET] The world is not perfect patch.
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0805210033m41e667dev6f7684b5495bdd6e@mail.gmail.com>
References: <eb3ff54b0805200229r6fb2daa1w50aaffa9b130f89f@mail.gmail.com>
	<20080520.143321.97817925.davem@davemloft.net>
	<eb3ff54b0805210033m41e667dev6f7684b5495bdd6e@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Wed, 21 May 2008 10:33:35 +0300

>   Unless there will be any objection here, I suggest consider the
> following patch which simply removes the code for the
> -DI_WISH_WORLD_WERE_PERFECT in the three methods which use it.
> 
> The compilation errors we get when using -DI_WISH_WORLD_WERE_PERFECT
> show that this code was not built and not used for really a long time.

Applied, thanks for following up on this Rami.
