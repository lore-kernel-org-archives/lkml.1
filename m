Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0BPFy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:54:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41395
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370Ab0BPFyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:54:53 -0500
Date: Mon, 15 Feb 2010 21:55:09 -0800 (PST)
Message-Id: <20100215.215509.251151533.davem@davemloft.net>
To: andrew.hendry@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] X25: Dont let x25_bind use addresses containing
 characters
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266148845.4731.45.camel@ibex>
References: <1266148845.4731.45.camel@ibex>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Hendry <andrew.hendry@gmail.com>
Date: Sun, 14 Feb 2010 23:00:45 +1100

> Addresses should be all digits.
> Stops x25_bind using addresses containing characters.
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

Applied.
