Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZKQLvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZKQLvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZKQLvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:51:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50828
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbZKQLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:51:30 -0500
Date: Tue, 17 Nov 2009 03:51:47 -0800 (PST)
Message-Id: <20091117.035147.80164577.davem@davemloft.net>
To: khali@linux-fr.org
Cc: sfr@canb.auug.org.au, bhutchings@solarflare.com, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       mika.kuoppala@nokia.com, linux-i2c@vger.kernel.org
Subject: Re: Shared i2c adapter locking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091117103554.03971b2f@hyperion.delvare>
References: <20091105150715.692b5200@hyperion.delvare>
	<20091117193313.b750804e.sfr@canb.auug.org.au>
	<20091117103554.03971b2f@hyperion.delvare>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>
Date: Tue, 17 Nov 2009 10:35:54 +0100

> If you did and something is still not clear, please let me know. My
> understanding is that the action token is in David's hands now.

So what exactly do I need to do?

All I see that needs to happen is to pull from Linus's tree into
net-2.6

But frankly I don't see how that helps resolve anything in linux-next
since Stephen starts with Linus's tree then pulls in everyone's work.

Or is that pull necessary so that some other patch can be applied
to net-2.6 or similar?
