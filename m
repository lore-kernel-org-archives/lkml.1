Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab0CMTzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:55:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38904
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab0CMTze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:55:34 -0500
Date: Sat, 13 Mar 2010 11:55:55 -0800 (PST)
Message-Id: <20100313.115555.209991546.davem@davemloft.net>
To: thisdyingdream@gmail.com
Cc: sjharms@gmail.com, mcarlson@broadcom.com, mchan@broadcom.com,
       benli@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sharms@ubuntu.com
Subject: Re: [PATCH] NET: tg3: fix brace, switch, and comma spacing coding
 style in tg3.c This is a patch to the tg3.c file that aligns switch and
 case statements, else statements following braces, and inserts a space
 after commas listed in the coding style g
From: David Miller <davem@davemloft.net>
In-Reply-To: <b6bf7b051003131152t38c8b1e1m33e8844468b9e46a@mail.gmail.com>
References: <b6bf7b051003131152t38c8b1e1m33e8844468b9e46a@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Harms <thisdyingdream@gmail.com>
Date: Sat, 13 Mar 2010 14:52:26 -0500

> Would you like me to submit the patch adding only the spaces after
> commas and leave the rest of the defines as is, or discard the changes
> all together?

I would like you to toss them altogether.
