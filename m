Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215Ab0ADFn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0ADFn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185Ab0ADFnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:43:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51825
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182Ab0ADFnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:43:20 -0500
Date: Sun, 03 Jan 2010 21:43:24 -0800 (PST)
Message-Id: <20100103.214324.252834689.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] niu: timeout ignored in tcam_wait_bit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B376AF3.6090408@gmail.com>
References: <4B376AF3.6090408@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 27 Dec 2009 15:10:59 +0100

> With `while (--limit > 0)' i reaches 0 after the loop, so upon timeout the
> error was not returned.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.
