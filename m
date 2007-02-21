Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXBUPDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXBUPDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXBUPDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:03:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32828 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbXBUPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:03:39 -0500
Date: Wed, 21 Feb 2007 16:07:28 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to limit flip buffer size in tty driver?
Message-ID: <20070221160728.49f024b6@lxorguk.ukuu.org.uk>
In-Reply-To: <45DAEE93.000001.01672@webmail16.yandex.ru>
References: <45DAB02A.000001.11699@soapbox.yandex.ru>
	<20070220125329.55fb7210@localhost.localdomain>
	<45DAEE93.000001.01672@webmail16.yandex.ru>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 15:50:27 +0300 (MSK)
"Mockern" <Mockern@yandex.ru> wrote:

> Thank you Alan for your respond,
> 
> Could you help me with a problem which I have with my tty driver, please?
> 
> It does not work with Linux cat operation (but there are no problems to write, read with select from user space application!). 

Looking at the trace I am confused as to what does not work ? Can you
explain the way in which it doesn't work ?
