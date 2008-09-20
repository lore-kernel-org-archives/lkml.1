Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYITKeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYITKeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYITKdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:33:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47697
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYITKds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:33:48 -0400
Date: Sat, 20 Sep 2008 03:33:36 -0700 (PDT)
Message-Id: <20080920.033336.39652163.davem@davemloft.net>
To: brice@myri.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for .28
From: David Miller <davem@davemloft.net>
In-Reply-To: <48D4A618.5080403@myri.com>
References: <20080914022236.GA15673@havoc.gtf.org>
	<20080920.000914.219711773.davem@davemloft.net>
	<48D4A618.5080403@myri.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brice Goglin <brice@myri.com>
Date: Sat, 20 Sep 2008 09:28:24 +0200

> Ok, I'll resend without the select_queue stuff. But you should really
> document the above explanation. The only documentation we found was
> "Devices or device layers can set this to control the queue selection
> performed by dev_pick_tx()." in the git-log...

Sure.

On your part, I would suggest that when you run into a problem that
many other multiqueue drivers will likely face, that you bring it up
here for discussion instead of implementing localized solutions :-)
