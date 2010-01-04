Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171Ab0ADFnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0ADFnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111Ab0ADFnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:43:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51820
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab0ADFnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:43:15 -0500
Date: Sun, 03 Jan 2010 21:43:19 -0800 (PST)
Message-Id: <20100103.214319.240976218.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atarilance: timeout ignored in lance_open()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B376074.2060305@gmail.com>
References: <4B376074.2060305@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 27 Dec 2009 14:26:12 +0100

> With `while (--i > 0)' i reaches 0 after the loop, so upon timeout the
> error was not issued.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.
