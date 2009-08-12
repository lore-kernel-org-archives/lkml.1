Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZHLXZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZHLXZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZHLXZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:25:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbZHLXZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:25:07 -0400
Date: Wed, 12 Aug 2009 16:25:17 -0700 (PDT)
Message-Id: <20090812.162517.13032565.davem@davemloft.net>
To: tj@kernel.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/2 2.6.31-rc5 REPOST] percpu, sparc64: fix sparse
 possible cpu map handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A825CD5.3060209@kernel.org>
References: <20090806115705.GB10734@elte.hu>
	<4A7B01B8.8000902@kernel.org>
	<4A825CD5.3060209@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Wed, 12 Aug 2009 15:10:29 +0900

> Tejun Heo wrote:
>> Ingo Molnar wrote:
>>> for the x86 bits:
>>>
>>>  Acked-by: Ingo Molnar <mingo@elte.hu>
>>>
>>> Once Dave acks it i suspect you can send it to Linus directly?
> 
> Aieeeee, no response.

These patches look fine, and I've tested them also on my
Niagara-2 box.

Acked-by: David S. Miller <davem@davemloft.net>

Sorry for the delay :)
