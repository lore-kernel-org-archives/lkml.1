Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbXFAEdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbXFAEdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXFAEdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:33:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35642
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbXFAEdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:33:39 -0400
Date: Thu, 31 May 2007 21:33:52 -0700 (PDT)
Message-Id: <20070531.213352.109885494.davem@davemloft.net>
To: notting@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix comparisons of unsigned < 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070530075613.GA29081@nostromo.devel.redhat.com>
References: <20070530075613.GA29081@nostromo.devel.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Nottingham <notting@redhat.com>
Date: Wed, 30 May 2007 03:56:13 -0400

> Recent gcc versions emit warnings when unsigned variables are compared < 0 or >= 0.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>

Patch applied, thanks.
