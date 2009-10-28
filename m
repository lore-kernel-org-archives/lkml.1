Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZJ1FbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZJ1FbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZJ1FbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:31:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44132
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757328AbZJ1FbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:31:02 -0400
Date: Tue, 27 Oct 2009 22:31:26 -0700 (PDT)
Message-Id: <20091027.223126.239262072.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch net-next]atl1c: duplicate atl1c_get_tpd
From: David Miller <davem@davemloft.net>
In-Reply-To: <12567068551959-git-send-email-jie.yang@atheros.com>
References: <12567068551959-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Wed, 28 Oct 2009 13:14:15 +0800

> From: Jie Yang <jie.yang@atheros.com>
> 
> remove duplicate atl1c_get_tpd, it may cause hardware to send wrong packets.
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Applied, thanks.
