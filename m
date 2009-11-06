Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZKFIbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZKFIbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZKFIbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:31:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33368
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbZKFIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:31:50 -0500
Date: Fri, 06 Nov 2009 00:32:15 -0800 (PST)
Message-Id: <20091106.003215.189008196.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1c:change atl1c_buffer struct and
 restructure clean atl1c_buffer procedure
From: David Miller <davem@davemloft.net>
In-Reply-To: <12574319533672-git-send-email-jie.yang@atheros.com>
References: <12574319533672-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Thu, 5 Nov 2009 22:39:13 +0800

> change atl1c_buffer struct, use "u16 flags" instead of "u16 state"
> to store more infomation for atl1c_buffer, and restructure clean
> atl1c_buffer procedure, add common api atl1c_clean_buffer.
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Applied, thanks.
