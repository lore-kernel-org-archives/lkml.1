Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab0CIGyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:54:21 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:54133 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0CIGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:54:19 -0500
Message-Id: <201003090654.o296sCnh065487@www262.sakura.ne.jp>
Subject: Re: [2.6.34-rc1] CPU stalls when closing TCP sockets.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Mar 2010 15:54:12 +0900
References: <201003090319.o293J6WF026448@www262.sakura.ne.jp> <1268116647.2819.64.camel@edumazet-laptop>
In-Reply-To: <1268116647.2819.64.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 08032010 #3512728, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Nothing comes to my mind, I'll try to reproduce this here.

When stopped at (8), Ctrl-C doesn't work.

> Is 2.6.33 OK ?

Yes. 2.6.33 and earlier are OK.

Regards.
