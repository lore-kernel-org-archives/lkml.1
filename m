Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZAZUZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZAZUZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZAZUYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:24:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59967
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbZAZUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:24:48 -0500
Date: Mon, 26 Jan 2009 12:24:50 -0800 (PST)
Message-Id: <20090126.122450.179476376.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: kkeil@suse.de, venza@brownhat.org, kernel-janitors@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix missing ifdef in isdn_ppp
From: David Miller <davem@davemloft.net>
In-Reply-To: <154e089b0901230144o2b52c232kb93a71429fb258a9@mail.gmail.com>
References: <20090122221827.GA28623@pingi.kke.suse.de>
	<154e089b0901230144o2b52c232kb93a71429fb258a9@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Fri, 23 Jan 2009 10:44:11 +0100

> Add CC. I think this could go upstream via David Miller's net-2.6 tree.

Yep, applied, thanks everyone.
