Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZHBUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZHBUTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZHBUTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:19:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56856
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727AbZHBUTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:19:13 -0400
Date: Sun, 02 Aug 2009 13:19:21 -0700 (PDT)
Message-Id: <20090802.131921.19721973.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: julia@diku.dk, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/15] drivers/ide/ide-cd.c: Use DIV_ROUND_CLOSEST
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090802135122.GA15279@liondog.tnic>
References: <Pine.LNX.4.64.0908021049350.15557@ask.diku.dk>
	<20090802135122.GA15279@liondog.tnic>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Sun, 2 Aug 2009 15:51:22 +0200

> On Sun, Aug 02, 2009 at 10:49:54AM +0200, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>> 
>> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
>> but is perhaps more readable.
>> 
 ...
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Acked-by: Borislav Petkov <petkovbb@gmail.com>

Applied to ide-next-2.6, thanks.
