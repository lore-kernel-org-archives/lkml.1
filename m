Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZLSEaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZLSEaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 23:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZLSEaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 23:30:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47574
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756063AbZLSEaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 23:30:21 -0500
Date: Fri, 18 Dec 2009 20:30:23 -0800 (PST)
Message-Id: <20091218.203023.232749150.davem@davemloft.net>
To: keil@b1-systems.de
Cc: yong.zhang0@gmail.com, linux-kernel@vger.kernel.org, andreas@eversberg.eu,
       acme@redhat.com
Subject: Re: [PATCH 4/5] mISDN: use DECLARE_COMPLETION_ONSTACK for
 non-constant completion
From: David Miller <davem@davemloft.net>
In-Reply-To: <200912162000.20642.keil@b1-systems.de>
References: <1260974161-6934-4-git-send-email-yong.zhang0@gmail.com>
	<1260974161-6934-5-git-send-email-yong.zhang0@gmail.com>
	<200912162000.20642.keil@b1-systems.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <keil@b1-systems.de>
Date: Wed, 16 Dec 2009 20:00:20 +0100

> The _ONSTACK variant should be used for on-stack completion,
> otherwise it will break lockdep.
>  
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: Karsten Keil <keil@b1-systems.de>

Applied, thanks.
