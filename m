Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZDVJZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZDVJZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZDVJYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:24:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42705
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754121AbZDVJYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:24:50 -0400
Date: Wed, 22 Apr 2009 02:24:42 -0700 (PDT)
Message-Id: <20090422.022442.248600629.davem@davemloft.net>
To: jkosina@suse.cz
Cc: ormi.linux@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, p_gortmaker@yahoo.com,
       trivial@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH]8390p: Get rid of init_module/cleanup_module
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.0904201744380.13028@wotan.suse.de>
References: <667b0cb60904110555k442f3959k9140d355b00980cd@mail.gmail.com>
	<alpine.LNX.2.00.0904201744380.13028@wotan.suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Mon, 20 Apr 2009 17:46:19 +0200 (CEST)

> On Sat, 11 Apr 2009, Mateusz Mandera wrote:
> 
>> This trivial patch just "gets rid of" init_module and cleanup_module
>> from drivers/net/8390p.c
>> 
>> Signed-off-by: Mateusz Mandera <ormi.linux@gmail.com>
 ...
> I'd rather have this merged through subsystem tree than trivial tree, 
> adding netdev to CC.

Applied to net-next-2.6, thanks.
