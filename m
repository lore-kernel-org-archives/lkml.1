Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZIOAHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZIOAHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZIOAHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:07:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58880
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbZIOAHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:07:10 -0400
Date: Mon, 14 Sep 2009 17:07:26 -0700 (PDT)
Message-Id: <20090914.170726.40013045.davem@davemloft.net>
To: vapier@gentoo.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com
Subject: Re: [PATCH] netdev: smc91x: drop Blackfin cruft
From: David Miller <davem@davemloft.net>
In-Reply-To: <1252951422-11543-1-git-send-email-vapier@gentoo.org>
References: <1252951422-11543-1-git-send-email-vapier@gentoo.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 14 Sep 2009 14:03:42 -0400

> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Now that all Blackfin boards are using the board resources, we don't need
> to keep the arch/board specific crap in the driver header.
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied.
