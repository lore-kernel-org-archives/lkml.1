Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYKXNjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYKXNjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 08:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYKXNix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 08:38:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:64779 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752208AbYKXNiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 08:38:52 -0500
Message-ID: <492AAE6C.7000103@ru.mvista.com>
Date: Mon, 24 Nov 2008 16:38:52 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Shane McDonald <mcdonald.shane@gmail.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
References: <E1L4UpB-0007ro-1g@localhost>	<492A8306.9000400@ru.mvista.com>	<492A9A1F.50401@ru.mvista.com> <20081124123231.555f2395@lxorguk.ukuu.org.uk>
In-Reply-To: <20081124123231.555f2395@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>>  It's 240, not 242 ns as 33 is actually 33.333.

>>   The maximum values give cycle time of 480 ns menaing that the 
>>controller doesn't support PIO mode 0. Hm...

> Even if you clear the enable for the timing register ?

    These fast timing bits are documented as reserved.

> Alan

MBR, Sergei
