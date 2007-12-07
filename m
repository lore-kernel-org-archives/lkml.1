Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXLGIwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXLGIwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXLGIvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:51:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48861
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbXLGIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:51:53 -0500
Date: Fri, 07 Dec 2007 00:51:52 -0800 (PST)
Message-Id: <20071207.005152.254396014.davem@davemloft.net>
To: crquan@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/20] net/iucv/iucv.c: use LIST_HEAD instead of
 LIST_HEAD_INIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <1196957605-5797-3-git-send-email-crquan@gmail.com>
References: <1196957605-5797-1-git-send-email-crquan@gmail.com>
	<1196957605-5797-2-git-send-email-crquan@gmail.com>
	<1196957605-5797-3-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Fri,  7 Dec 2007 00:13:25 +0800

> these three list_head are all local variables, but can also use LIST_HEAD.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Applied.
