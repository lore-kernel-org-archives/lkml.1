Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXEQSZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXEQSZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbXEQSZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:25:17 -0400
Received: from h155.mvista.com ([63.81.120.155]:25082 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760779AbXEQSZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:25:15 -0400
Message-ID: <464C9E67.2020909@ru.mvista.com>
Date: Thu, 17 May 2007 22:26:47 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
Cc: tglx@linutronix.de, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com> <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org> <464C99FF.8080404@ru.mvista.com> <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
In-Reply-To: <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kumar Gala wrote:

> I haven't looked at all the new clock/timer code, is there any  utility 
> in having support for more than one clock source?

    Of course, you may register as many as you like.

> - k

WBR, Sergei
