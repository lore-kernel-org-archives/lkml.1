Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXEUJlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXEUJlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXEUJlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:41:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38781 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbXEUJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:41:45 -0400
Message-ID: <46516954.6030608@garzik.org>
Date: Mon, 21 May 2007 05:41:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, l.genoni@oltrelinux.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: something strange in libata-core.c for kernel 2.6.22-rc3
References: <fa.MCe9nCgx+WnsHp+weZyM9LiDF0s@ifi.uio.no> <fa.rv8/6n3uBnAIoUHHNUW3eR7cJd8@ifi.uio.no> <fa.LXy58QwLlPXDhsfVUU9kEfA3QbI@ifi.uio.no> <fa.Ldjy2OubeKomZD0OV2gRm/wpUFo@ifi.uio.no> <46515983.6030206@shaw.ca>
In-Reply-To: <46515983.6030206@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid BIOS crap like that is largely the reason why I am reluctant to 
merge pata_acpi.  There is a lot of knowledge like this yet to be 
discovered.

I would feel far more comfortable disassembling the AML like you are 
doing...

	Jeff



