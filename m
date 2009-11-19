Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZKSHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZKSHaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 02:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZKSHae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 02:30:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32775
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbZKSHae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 02:30:34 -0500
Date: Wed, 18 Nov 2009 23:30:51 -0800 (PST)
Message-Id: <20091118.233051.80180466.davem@davemloft.net>
To: andrew.hendry@gmail.com
Cc: netdev@vger.kernel.org, linux-x25@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X25: Enable setting of cause and diagnostic fields
From: David Miller <davem@davemloft.net>
In-Reply-To: <d45a3acc0911181524t58a87d07s42930bda765a97d7@mail.gmail.com>
References: <d45a3acc0911111613v38fa9df4jed21876ce6309097@mail.gmail.com>
	<20091113.203248.84989794.davem@davemloft.net>
	<d45a3acc0911181524t58a87d07s42930bda765a97d7@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: andrew hendry <andrew.hendry@gmail.com>
Date: Thu, 19 Nov 2009 10:24:01 +1100

> Adds SIOCX25SCAUSEDIAG, allowing X.25 programs to set the cause and
> diagnostic fields.
> Normally used to indicate status upon closing connections.
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

Applied, thanks.
