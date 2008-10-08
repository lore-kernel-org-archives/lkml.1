Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYJHQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYJHQii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYJHQi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:38:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44444
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbYJHQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:38:27 -0400
Date: Wed, 08 Oct 2008 09:38:02 -0700 (PDT)
Message-Id: <20081008.093802.133779887.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: minyard@acm.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <48EC70BB.9010709@cosmosbay.com>
References: <48EAF29D.8050203@cosmosbay.com>
	<20081007.112622.73930718.davem@davemloft.net>
	<48EC70BB.9010709@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 08 Oct 2008 10:35:07 +0200

> BTW is there any chance your results were obtained before October 2005 ?

No, the timestamp on the saved patch file I have is June 16, 2008 :-)
