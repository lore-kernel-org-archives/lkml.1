Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbXJBJVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbXJBJVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXJBJUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:20:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:64613 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXJBJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VULrsdmFuLKsqKvM3a4j/+FZ7y/azV00JdqbKc+YO6GU0zm+Tlgn5YHBf96x1z9OvX9Oj99pcTwxynAd4FGTzA0/kODrSUcoH9SNmrxN2EKPUB0b7Z5BP9cJh4pCo1FoMGQCIpWR7xsXoGDFKYmCvZK2q895rVe0JM5wjGbI2oI=
Message-ID: <47020D12.5090402@gmail.com>
Date: Tue, 02 Oct 2007 18:19:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Mark Lord <lkml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Paolo Ornati <ornati@fastwebnet.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <20070930160548.235be972@localhost>	<20070930152908.1f58d39d@the-village.bc.nu> <20070930164610.20818867@localhost> <46FFBB2D.6060004@garzik.org> <46FFDC5A.7070509@rtr.ca> <46FFDCE5.4060900@gmail.com> <46FFE047.7030102@rtr.ca> <46FFE218.5000607@gmail.com> <46FFF0F4.7040809@rtr.ca> <46FFF290.2090005@rtr.ca>
In-Reply-To: <46FFF290.2090005@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mark Lord wrote:
> Mmm.. $66 for "open box".  But the drive itself has been discontinued by
> Seagate,

Couldn't find any in SUSE and I don't think I can't find any vendor who
still carries the drive here.

> and once claimed to be "World's first SATA desktop drive with NCQ.".
> 
> Probably buggy firmware after all.

Yeah, "World's first" is a pretty good clue indicating "broken".
Blacklisting it seems like a good idea after all.

Thanks.

-- 
tejun
