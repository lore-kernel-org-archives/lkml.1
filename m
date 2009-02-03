Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZBCHTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZBCHTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 02:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZBCHTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 02:19:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33796
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbZBCHS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 02:18:59 -0500
Date: Mon, 02 Feb 2009 23:18:56 -0800 (PST)
Message-Id: <20090202.231856.127177453.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: dwalker@fifo99.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: variables reach -1, but 0 tested
From: David Miller <davem@davemloft.net>
In-Reply-To: <4985CC81.1040801@gmail.com>
References: <498429AE.1080404@gmail.com>
	<1233434112.5903.28.camel@desktop>
	<4985CC81.1040801@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 01 Feb 2009 17:23:29 +0100

> Ok, here it is again:
> 
> while (timeout--) { ... }
> 
> timeout becomes -1 if the loop isn't ended otherwise, not 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.
