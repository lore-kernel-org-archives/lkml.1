Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXGRJMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXGRJMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXGRJMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:12:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45885
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbXGRJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:12:22 -0400
Date: Wed, 18 Jul 2007 02:12:21 -0700 (PDT)
Message-Id: <20070718.021221.84974075.davem@davemloft.net>
To: crquan@gmail.com
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, kaber@coreworks.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [net/core] merge dev_unicast_discard and
 dev_mc_discard into one
From: David Miller <davem@davemloft.net>
In-Reply-To: <11847264751175-git-send-email-crquan@gmail.com>
References: <11846606051099-git-send-email-crquan@gmail.com>
	<11847264651509-git-send-email-crquan@gmail.com>
	<11847264751175-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Wed, 18 Jul 2007 10:41:04 +0800

> this two functions could share the dev->_xmit_lock acquired context.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Applied, thanks.
