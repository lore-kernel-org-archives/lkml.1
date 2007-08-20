Return-Path: <linux-kernel-owner+w=401wt.eu-S1761780AbXHTVKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761780AbXHTVKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXHTVKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:10:44 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:39251 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1752324AbXHTVKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:10:43 -0400
Message-ID: <46CA035A.5050202@ru.mvista.com>
Date: Tue, 21 Aug 2007 01:10:50 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
CC: RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
In-Reply-To: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Baydarov wrote:
> Hi, I've faced problem:
> I have two x86_64 kernels with HPET enabled:
> kernel 1 - with PM enabled,
> kernel 2 - with PM disabled.
>   
Forgot to say that it's RT kernel, version is 2.6.23-rc2-rt2.
