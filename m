Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbXERPrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbXERPrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbXERPrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:47:04 -0400
Received: from h155.mvista.com ([63.81.120.155]:31908 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755761AbXERPrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:47:02 -0400
Message-ID: <464DCACF.9070704@ru.mvista.com>
Date: Fri, 18 May 2007 19:48:31 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, tglx@linutronix.de, mingo@elte.hu,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com>	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>	 <464C99FF.8080404@ru.mvista.com>	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>	 <1179500217.20519.53.camel@imap.mvista.com>	 <464DC0DC.7050809@ru.mvista.com> <1179502773.20519.56.camel@imap.mvista.com>
In-Reply-To: <1179502773.20519.56.camel@imap.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Daniel Walker wrote:

>>    Well, the decrementer frequency may change, at least in theory (if the bus 
>>clock changes).

> Does that happen very often?

    Never, I hope. :-)

> Daniel

WBR, Sergei
