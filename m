Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXBTLtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXBTLtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbXBTLtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:49:42 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55446 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964825AbXBTLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:49:42 -0500
Date: Tue, 20 Feb 2007 12:53:29 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to limit flip buffer size in tty driver?
Message-ID: <20070220125329.55fb7210@localhost.localdomain>
In-Reply-To: <45DAB02A.000001.11699@soapbox.yandex.ru>
References: <45DAB02A.000001.11699@soapbox.yandex.ru>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 11:24:10 +0300 (MSK)
"Mockern" <Mockern@yandex.ru> wrote:

> Hello,
> 
> how to limit flip buffer size in tty driver?

You don't.

See Documentation/tty.txt and throttle/unthrottle

Alan
