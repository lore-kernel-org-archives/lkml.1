Return-Path: <linux-kernel-owner+w=401wt.eu-S934027AbZLMBoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027AbZLMBoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933711AbZLMBoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:44:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56501
	"HELO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933911AbZLMBod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:44:33 -0500
Date: Sat, 12 Dec 2009 17:44:31 -0800 (PST)
Message-Id: <20091212.174431.147974106.davem@davemloft.net>
To: w@1wt.eu
Cc: linux-kernel@vger.kernel.org, matti.aarnio@zmailer.org,
       mgalgoci@redhat.com
Subject: Re: Vger outage on Dec 12th and 13th
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091208214303.GB32739@1wt.eu>
References: <20091208.015956.200531033.davem@davemloft.net>
	<20091208214303.GB32739@1wt.eu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Tue, 8 Dec 2009 22:43:03 +0100

> would you happen to already know in advance its new IP address ?
> Some people (me included) white-list it so that incoming mails
> do not experience any form of filtering. In my case, I do that
> so that vger does not suffer from any SMTP HELO delay. Setting
> that in advance will make the migration smoother for everyone.

Sorry, I didn't know the new IP address until late last night.

It's obviously 209.132.180.67 as can be seen in current DNS,
and it is now back online.
