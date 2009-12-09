Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbZLIEsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbZLIEsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZLIEsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:48:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34360
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982AbZLIEsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:48:17 -0500
Date: Tue, 08 Dec 2009 20:48:24 -0800 (PST)
Message-Id: <20091208.204824.04911690.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: cmatei@profis.ro, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1c:use common_task instead of reset_task
 and link_chg_task
From: David Miller <davem@davemloft.net>
In-Reply-To: <1260177418354-git-send-email-jie.yang@atheros.com>
References: <1260177418354-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Mon, 7 Dec 2009 17:16:58 +0800

> From: Jie Yang <jie.yang@atheros.com>
> 
> use common_task instead of reset_task and link_chg_task, so it fix "call cancel_work_sync
> from the work itself".
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Applied.
