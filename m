Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZFVH2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZFVH2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZFVH2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:28:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50934
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbZFVH2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:28:30 -0400
Date: Mon, 22 Jun 2009 00:28:34 -0700 (PDT)
Message-Id: <20090622.002834.240476749.davem@davemloft.net>
To: vishwakarma.deepak@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: PF_RING for n/w traffic more than 1 Gbps
From: David Miller <davem@davemloft.net>
In-Reply-To: <e31d15d70906220020y70f0daf9k4650d96c402fdf7a@mail.gmail.com>
References: <e31d15d70906220020y70f0daf9k4650d96c402fdf7a@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Vishwakarma <vishwakarma.deepak@gmail.com>
Date: Mon, 22 Jun 2009 12:50:11 +0530

> PF_RING kernel patch not optimized for traffic handling more than 1
> Gbps. I am facing packet overrun over 1 Gbps with linux 2.6.30 patched
> with PF_RING.
> 
> Does any one has achieved more than 2-3 Gbps packet handling with or
> without PF_RING.

You'll have more luck with this question on the networking developer
list, netdev@vger.kernel.org, which has been CC:'d
