Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZDAIFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZDAIFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZDAIEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:04:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57770
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbZDAIEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:04:45 -0400
Date: Wed, 01 Apr 2009 01:04:33 -0700 (PDT)
Message-Id: <20090401.010433.85907053.davem@davemloft.net>
To: yinghai@kernel.org
Cc: tj@kernel.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove duplicated code with pcpu_need_numa()
From: David Miller <davem@davemloft.net>
In-Reply-To: <49D31770.9090502@kernel.org>
References: <86802c440903312256r6ddbaa22o5c23cf85d83a6662@mail.gmail.com>
	<49D30469.8020006@kernel.org>
	<49D31770.9090502@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 01 Apr 2009 00:27:44 -0700

> 
> Impact: clean up
> 
> those code pcpu_need_numa(), should be removed.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
