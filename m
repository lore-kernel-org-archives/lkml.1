Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYHUXvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYHUXvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYHUXvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:51:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYHUXvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:51:24 -0400
Message-ID: <48ADFDCA.1020702@zytor.com>
Date: Thu, 21 Aug 2008 16:44:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: LinuxPPS (RESUBMIT 7): the PPS Linux implementation.
References: <1219238170-5508-1-git-send-email-giometti@linux.it>	<48ADE317.5030809@zytor.com> <20080822002002.62ec1914@lxorguk.ukuu.org.uk>
In-Reply-To: <20080822002002.62ec1914@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> 2. I assume that with the PPS line discipline loaded you can still read
>>     the data from the main pins on the serial port (almost always used
>>     for metadata?)
> 
> Yes - thats why the ldisc was done inheriting from the N_TTY discipline.

Excellent.  It felt like a stupid question, but I thought I'd ask it anyway.

	-hpa
