Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXJMKzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXJMKzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 06:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761493AbXJMKzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 06:55:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33947 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761467AbXJMKza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 06:55:30 -0400
Message-ID: <4710A420.9000108@garzik.org>
Date: Sat, 13 Oct 2007 06:55:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [git patches] libata update
References: <20071012194002.GA1545@havoc.gtf.org> <20071013070535.D339CA364AB@smtp01.mtu.ru>
In-Reply-To: <20071013070535.D339CA364AB@smtp01.mtu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> Jeff Garzik wrote:
> 
>> * Asynchronous notification -- finally userspace CD-ROM polling can go
>> away!
>>   (NOTE: waiting on James B to apply the piece that actually makes this
>>   work...)
> 
> Does it depend on hardware offering suitable support? What are chances for
> it to work on 5 years old DVD-ROM?

Correct -- it requires a new SATA CD-ROM with the AN capability.

	Jeff



