Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0BIGhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:37:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36453
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab0BIGhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:37:18 -0500
Date: Mon, 08 Feb 2010 22:37:31 -0800 (PST)
Message-Id: <20100208.223731.192859791.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-2.6] cxgb3: fix GRO checksum check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100209005544.12679.3987.stgit@speedy5.asicdesigners.com>
References: <20100209005544.12679.3987.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 08 Feb 2010 16:55:44 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> Verify the HW checksum state for frames handed to GRO processing.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied, thanks.
