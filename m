Return-Path: <linux-kernel-owner+w=401wt.eu-S1750918AbXBKXJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbXBKXJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXBKXJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:09:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54699 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbXBKXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:09:52 -0500
Date: Sun, 11 Feb 2007 23:23:13 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211232313.345c51e2@localhost.localdomain>
In-Reply-To: <20070211224637.GC13913@1wt.eu>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	<fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	<fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no>
	<fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no>
	<fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no>
	<fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no>
	<45CF60F2.5020308@shaw.ca>
	<20070211215211.GB13913@1wt.eu>
	<1171232786.4493.62.camel@nigel.suspend2.net>
	<20070211224637.GC13913@1wt.eu>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm sorry, but we don't have the same usages of notebooks. For no reason
> would I keep documents open, for two reasons :
> 
>   - when I shutdown my notebook, it is to move from one customer to
>     home/company/another customer. There's no related work anyway, the
>     network will have changed and I'll have to switch nearly all of my
>     apps anyway. So using suspend just to save one reboot is not worth
>     it (for me) IMHO.
> 
>   - I would certainly not keep open documents that are on crypted FS
>     while I travel. 

You use the encryption patches for suspend. And even if you turn your
laptop off and leave it somewhere for a bit I can turn it on install a
trojan and turn it off again.

Suspend/Resume is supposed to work, many people find it useful. One non
suspend friendly driver makes every suspend aware driver on that
system useless so we really should be tight about suspend/resume.

Alan
