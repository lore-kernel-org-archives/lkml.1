Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZKWShy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZKWShy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZKWShx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:37:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35520
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZKWShx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:37:53 -0500
Date: Mon, 23 Nov 2009 10:38:10 -0800 (PST)
Message-Id: <20091123.103810.44071453.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: drivers/ide/au1xxx-ide.c: use resource_size()
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5C0C@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5BFD@mi8nycmail19.Mi8.com>
	<20091123.102817.157628485.davem@davemloft.net>
	<BD79186B4FD85F4B8E60E381CAEE190901EE5C0C@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 23 Nov 2009 13:37:05 -0500

> I don't have to hardware to test this so I didn't want to dig to deeply
> into fixing that.

Fair enough.
