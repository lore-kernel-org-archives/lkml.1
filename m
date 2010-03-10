Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab0CJXsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:48:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:36521 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab0CJXsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:48:07 -0500
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20100310.143602.266086944.davem@davemloft.net>
References: <4B9818CE.7090809@kernel.org>
	 <20100310.141757.95833226.davem@davemloft.net>
	 <4B981DBD.2060303@kernel.org>
	 <20100310.143602.266086944.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 10:47:17 +1100
Message-ID: <1268264837.22204.688.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 14:36 -0800, David Miller wrote:
> LMB could do this too with minor modifications.
> 
> Simply make the lmb.memory and lmb.reserved be pointers, and initially
> they point into the static array(s).
> 
> Later the pointers can be repositioned to point to dynamically
> allocated memory.
> 
> So please, for the third time, please show me how LMB with some minor
> modifications is not able to satisfy your needs. 

So I was about to say the exact same stuff here...

Cheers,
Ben.


