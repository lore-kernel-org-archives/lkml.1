Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXJ3VqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXJ3VqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXJ3VqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:46:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50558
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbXJ3Vp7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:45:59 -0400
Date: Tue, 30 Oct 2007 14:45:44 -0700 (PDT)
Message-Id: <20071030.144544.163064587.davem@davemloft.net>
To: oliver.pntr@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: compile error in 2.6.24-rc1-git6 HEAD is on
 ea45d15394c57cb214aef8e6d40976c128995d43
From: David Miller <davem@davemloft.net>
In-Reply-To: <6101e8c40710301344s5061235ej6a8b5558ae93b981@mail.gmail.com>
References: <6101e8c40710301344s5061235ej6a8b5558ae93b981@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Olivér_Pintér" <oliver.pntr@gmail.com>
Date: Tue, 30 Oct 2007 21:44:18 +0100

>   CHECK   include/linux/tipc_config.h
> /home/oliver/develop/kernel/v2.6.24-git1-git6+/usr/include/linux/tipc_config.h
> requires linux/string.h, which does not exist in exported headers
> make[3]: *** [/home/oliver/develop/kernel/v2.6.24-git1-git6+/usr/include/linux/.check.tipc_config.h]
> Error 1
> make[2]: *** [linux] Error 2
> make[1]: *** [headers_check] Error 2
> make: *** [vmlinux] Error 2

I'll take care of this, thanks for the report.
