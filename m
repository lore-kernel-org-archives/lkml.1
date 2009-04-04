Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZDDXjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZDDXjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 19:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZDDXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 19:39:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42990
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754576AbZDDXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 19:39:08 -0400
Date: Sat, 04 Apr 2009 16:38:57 -0700 (PDT)
Message-Id: <20090404.163857.103749063.davem@davemloft.net>
To: jaswinder@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH net-next] myri_sbus: use request_firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <1238701097.3099.82.camel@ht.satnam>
References: <1238701097.3099.82.camel@ht.satnam>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Fri, 03 Apr 2009 01:08:17 +0530

> Firmware blob looks like this...
> 
>         __be16 lanai4_data_size
>         unsigned char lanai4_code[]
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Applied, thanks.
