Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZIVVVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZIVVVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZIVVVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:21:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33899
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbZIVVVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:21:20 -0400
Date: Tue, 22 Sep 2009 14:21:38 -0700 (PDT)
Message-Id: <20090922.142138.267504699.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: akpm@linux-foundation.org, jirislaby@gmail.com, jcliburn@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch net-next]atl1c:remove compiling warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <12535093181069-git-send-email-jie.yang@atheros.com>
References: <12535093181069-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Mon, 21 Sep 2009 13:01:58 +0800

> Set wol_ctrl_data to value 0, to remove compiling warning.
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Applied.
