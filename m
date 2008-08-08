Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbYHHXU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbYHHXU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYHHXUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:20:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49191
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbYHHXUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:20:46 -0400
Date: Fri, 08 Aug 2008 16:20:47 -0700 (PDT)
Message-Id: <20080808.162047.163238935.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: yanivr@broadcom.com, eilong@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: precedence confusion !x & y
From: David Miller <davem@davemloft.net>
In-Reply-To: <489D1CA3.80504@gmail.com>
References: <489D1CA3.80504@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: roel kluin <roel.kluin@gmail.com>
Date: Sat, 09 Aug 2008 00:27:15 -0400

> ! has a higher precedence than &
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

This is already fixed in Linus's tree.
